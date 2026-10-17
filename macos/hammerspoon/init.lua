-- macOS companion to OmniWM 0.6.10. All native WM chords live in settings.toml.
require('hs.ipc')
local root = os.getenv('HOME') .. '/.dotfiles/macos'
local log = hs.logger.new('niri-mac', 'info')
niriMac = {hotkeys={}, bindings={}, failedBindings={}, tasks={}, enabled=true}
local M=niriMac
local function run(path,args,done,quiet)
  local task
  task=hs.task.new(path,function(code,out,err)
    M.tasks[task]=nil
    if code~=0 and not quiet then log.e(err); hs.alert.show((err~='' and err or '工具运行失败'):sub(1,240)) end
    if done then done(code,out,err) end
  end,args or {})
  if not task then hs.alert.show('无法启动 '..path); return end
  local env={HOME=os.getenv('HOME'),TMPDIR=os.getenv('TMPDIR'),LANG='en_US.UTF-8'}
  env.PATH=root..'/bin:/opt/homebrew/bin:/Library/TeX/texbin:/Applications/kitty.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin'
  task:setEnvironment(env); M.tasks[task]=true;task:start()
end
local function command(words,done,quiet)
  local args={'command'}; for _,v in ipairs(words) do args[#args+1]=v end
  args[#args+1]='--json';run('/opt/homebrew/bin/omniwmctl',args,done,quiet)
end
local function helper(words) run(root..'/bin/omni-helper.py',words) end
local function bind(mods,key,label,fn,repeatable)
  local sort={table.unpack(mods)}; table.sort(sort)
  local identity=table.concat(sort,'+')..'+'..key
  assert(not M.bindings[identity], 'Duplicate Hammerspoon key '..identity)
  M.bindings[identity]=label
  local hotkey=hs.hotkey.new(mods,key,fn,nil,repeatable and fn or nil)
  local registered=hotkey:enable();M.hotkeys[#M.hotkeys+1]=hotkey
  if not registered then M.failedBindings[#M.failedBindings+1]=identity;log.e('Shortcut unavailable: '..identity) end
end
local function launchTool(name) run(root..'/bin/launch-tool.sh',{name}) end
local function app(bundle) helper({'focus-app',bundle}) end
M.launchTool=launchTool
M.focusApp=app
M.command=command
-- Private dispatch chords. Physical Win is the separate Karabiner virtual Mod.
local mod={'ctrl','cmd'};local move={'ctrl','cmd','alt'};local across={'ctrl','cmd','shift'}
bind(mod,'return','kitty',function() launchTool('terminal') end)
bind(across,'return','Zen',function() app('app.zen-browser.zen') end)
bind(mod,'e','Finder',function() app('com.apple.finder') end)
bind(mod,'o','Obsidian',function() app('md.obsidian') end)
bind(mod,'z','Zotero',function() app('org.zotero.zotero') end)
bind(mod,'v','PDF viewer (Skim)',function() app('net.sourceforge.skim-app.skim') end)
-- This Mac's application named ChatGPT has this actual, inspected bundle ID.
bind(mod,'g','ChatGPT',function() app('com.openai.codex') end)
bind(across,'g','ChatGPT web',function() run('/usr/bin/open',{'https://chatgpt.com'}) end)
bind(across,'v','PDF search',function() launchTool('pdf') end)
bind(across,'z','Copy citekey',function() launchTool('citekey') end)
bind(move,'z','Open Zotero paper',function() launchTool('zotero-open') end)
bind(mod,'t','TODO',function() launchTool('todo') end)
bind(mod,'i','LaTeX scratch',function() launchTool('latex') end)
-- ZenNotes is deliberately left unbound until its macOS app is supplied.
bind(mod,'b','btop toggle',function()
  run('/opt/homebrew/bin/omniwmctl',{'query','windows','--bundle-id','net.kovidgoyal.kitty','--json'},function(code,out)
    if code==0 then
      local ok,data=pcall(hs.json.decode,out)
      if ok then for _,w in ipairs(data.result.payload.windows or {}) do
        if w.title=='niri-mac:Monitor' then run('/opt/homebrew/bin/omniwmctl',{'window','close',w.id});return end
      end end
    end
    launchTool('monitor')
  end,true)
end)
-- OmniWM supports one binding per action. H/L are native; arrow aliases use IPC.
for key,words in pairs({left={'focus','left'},right={'focus','right'}}) do
  bind(mod,key,'Focus '..key,function() command(words) end,true)
  bind(move,key,'Move column '..key,function() command({'move-column',key}) end,true)
end
bind(mod,'[','Consume/expel left',function() command({'consume-or-expel-window-left'}) end,true)
bind(mod,']','Consume/expel right',function() command({'consume-or-expel-window-right'}) end,true)
for key,direction in pairs({h='left',j='down',k='up',l='right',left='left',down='down',up='up',right='right'}) do
  bind(across,key,'Focus monitor '..direction,function() helper({'focus-monitor',direction}) end)
  bind({'ctrl','cmd','alt','shift'},key,'Move column to monitor '..direction,function() helper({'column-monitor',direction}) end)
end
bind(across,'f','Focus other layer',function() helper({'focus-layer'}) end)
-- OmniWM's palette searches existing windows/menus/clipboard, not installed apps.
-- Win+Space uses Hapigo native Command+Space; Win+Shift+Space launches Spotlight.
bind(across,'space','Launch application (Spotlight)',function() run('/usr/bin/open',{'-a','/System/Library/CoreServices/Spotlight.app'}) end)
function M.clipboardImage()
  local img=hs.pasteboard.readImage()
  if not img then hs.alert.show('剪贴板中没有可读取的图片');return false end
  local dir=os.getenv('TMPDIR') or '/tmp/'
  local path=dir..'niri-mac-clipboard-'..hs.timer.absoluteTime()..'.png'
  if not img:saveToFile(path) then hs.alert.show('剪贴板图片保存失败');return false end
  run('/usr/bin/open',{'-a','Preview',path});return true
end
bind({},'f4','Clipboard image',M.clipboardImage)
local function volume(delta)
  local device=hs.audiodevice.defaultOutputDevice()
  if device then device:setVolume(math.max(0,math.min(100,(device:volume() or 0)+delta))) end
end
bind({},'f10','Mute',function() local d=hs.audiodevice.defaultOutputDevice();if d then d:setMuted(not d:muted()) end end)
bind({},'f12','Volume up',function() volume(2) end,true)
-- F11 is reserved by macOS Show Desktop; F1 also failed Carbon registration
-- on this Mac. Intercept only these unmodified function keys before dispatch.
-- Physical media/brightness events and all modified F-keys retain their behavior.
M.bindings['+f1']='Screenshot (event tap)'
M.bindings['+f11']='Volume down (event tap)'
M.functionKeys=hs.eventtap.new({hs.eventtap.event.types.keyDown,hs.eventtap.event.types.keyUp},function(e)
  local f=e:getFlags();local key=e:getKeyCode()
  if not M.enabled or f.alt or f.ctrl or f.shift or f.cmd or hs.eventtap.isSecureInputEnabled() then return false end
  if key~=hs.keycodes.map.f1 and key~=hs.keycodes.map.f11 then return false end
  if e:getType()==hs.eventtap.event.types.keyDown then
    if key==hs.keycodes.map.f11 then volume(-2)
    elseif e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat)==0 then run('/usr/sbin/screencapture',{'-i','-c'}) end
  end
  return true
end)
if hs.accessibilityState() then M.functionKeys:start() end
bind(move,'space','Play/pause',function() hs.eventtap.event.newSystemKeyEvent('PLAY',true):post();hs.eventtap.event.newSystemKeyEvent('PLAY',false):post() end)
bind(move,'pagedown','Next track',function() hs.eventtap.event.newSystemKeyEvent('NEXT',true):post();hs.eventtap.event.newSystemKeyEvent('NEXT',false):post() end)
bind(move,'pageup','Previous track',function() hs.eventtap.event.newSystemKeyEvent('PREVIOUS',true):post();hs.eventtap.event.newSystemKeyEvent('PREVIOUS',false):post() end)
bind(across,'p','Display sleep',function() run('/usr/bin/pmset',{'displaysleepnow'}) end)
bind(move,'f10','Microphone mute',function() local d=hs.audiodevice.defaultInputDevice();if d then d:setMuted(not d:muted()) end end)
bind({},'f9','Output device',function()
  local choices={}
  for _,d in ipairs(hs.audiodevice.allOutputDevices()) do choices[#choices+1]={text=d:name(),uuid=d:uid()} end
  M.audioChooser=hs.chooser.new(function(choice)
    if choice then local d=hs.audiodevice.findDeviceByUID(choice.uuid);if d then d:setDefaultOutputDevice() end end
  end):choices(choices):show()
end)
-- Win+Escape pauses this workflow; the Karabiner Mod bridge remains available to resume it.
M.escape=hs.hotkey.bind(mod,'escape',function()
  M.enabled=not M.enabled
  for _,h in ipairs(M.hotkeys) do if M.enabled then h:enable() else h:disable() end end
  helper({'hotkeys',M.enabled and 'true' or 'false'})
  hs.alert.show(M.enabled and 'niri 快捷键已启用' or 'niri 快捷键已暂停；Win+Esc 恢复')
end)
-- F18 is only a held-state signal from Karabiner, never an app shortcut.
M.winDown=false
M.winSignal=hs.eventtap.new({hs.eventtap.event.types.keyDown,hs.eventtap.event.types.keyUp},function(e)
  if e:getKeyCode()~=hs.keycodes.map.f18 then return false end
  M.winDown=e:getType()==hs.eventtap.event.types.keyDown
  return true
end)
if hs.accessibilityState() then M.winSignal:start() end
local function resetMod()
  M.winDown=false
  run('/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli',
    {'--set-variables','{"niri_mac_win":0}'},nil,true)
end
resetMod()
local lastScroll=0
M.scroll=hs.eventtap.new({hs.eventtap.event.types.scrollWheel},function(e)
  local f=e:getFlags()
  if not M.enabled or not M.winDown or f.alt or (f.ctrl and f.cmd) or hs.eventtap.isSecureInputEnabled() then return false end
  local props=hs.eventtap.event.properties
  -- Only discrete mouse wheel ticks; normal trackpad scroll stays with the app.
  if e:getProperty(props.scrollWheelEventIsContinuous)==1 then return false end
  local y=e:getProperty(props.scrollWheelEventDeltaAxis1)
  local x=e:getProperty(props.scrollWheelEventDeltaAxis2)
  if y==0 and x==0 then return false end
  local now=hs.timer.secondsSinceEpoch()
  if now-lastScroll<0.15 then return true end
  lastScroll=now
  local moving=f.ctrl or f.cmd
  if f.shift or math.abs(x)>math.abs(y) then
    local right=f.shift and y<0 or (not f.shift and x<0)
    command({moving and 'move-column' or 'focus',right and 'right' or 'left'})
  elseif moving then command({'move-column-to-workspace',y<0 and 'down' or 'up'})
  else command({'switch-workspace',y<0 and 'next' or 'prev'}) end
  return true
end)
if hs.accessibilityState() then M.scroll:start() end
-- Three-finger swipes match Win+H/J/K/L once per contact sequence.
-- macOS Spaces and Mission Control use four fingers.
M.threeFinger=dofile(root..'/hammerspoon/three-finger-swipe.lua')(function(direction)
  local args=(direction=='up' or direction=='down')
    and {'focus-window-or-workspace-'..direction} or {'focus',direction}
  command(args,function(code,out,err)
    local ok,result=pcall(hs.json.decode,out)
    M.threeFinger.lastCommand={direction=direction,exitCode=code,
      resultCode=ok and result.code or nil,time=hs.timer.secondsSinceEpoch()}
    if code~=0 and not (ok and result.code=='no_change') then
      log.e('Three-finger focus failed: '..(err~='' and err or out))
      hs.alert.show('OmniWM 三指导航失败，请检查是否正在运行')
    end
  end,true)
end)
M.threeFingerTap=hs.eventtap.new({hs.eventtap.event.types.gesture,hs.eventtap.event.types.scrollWheel},function(e)
  local f=e:getFlags()
  if not M.enabled or M.winDown or f.alt or f.ctrl or f.shift or f.cmd or hs.eventtap.isSecureInputEnabled() then
    M.threeFinger:reset();return false
  end
  local now=hs.timer.absoluteTime()/1000000000
  if e:getType()==hs.eventtap.event.types.scrollWheel then
    local p=hs.eventtap.event.properties
    if e:getProperty(p.scrollWheelEventIsContinuous)~=1 then return false end
    return M.threeFinger:consumeScroll(now,e:getProperty(p.scrollWheelEventMomentumPhase)~=0)
  end
  if e:getType(true)~=hs.eventtap.event.types.gesture then return false end
  return M.threeFinger:process(e:getTouches(),now)
end)
if hs.accessibilityState() then M.threeFingerTap:start() end
-- Initial floating proportions are only applied to precisely identified windows.
local sized={}
M.windows=hs.window.filter.new(false)
M.windows:setDefaultFilter({})
M.windows:subscribe({hs.window.filter.windowCreated,hs.window.filter.windowTitleChanged},function(w)
  if not w or sized[w:id()] then return end
  local a=w:application();local bundle=a and a:bundleID() or '';local title=w:title() or ''
  local ratio,absolute
  local toolTitles={['niri-mac:PDF']=true,['niri-mac:Zotero Citekey']=true,['niri-mac:Zotero Open']=true,['niri-mac:TODO']=true,['niri-mac:Monitor']=true,['niri-mac:LaTeX']=true}
  if bundle=='net.kovidgoyal.kitty' and toolTitles[title] then
    if title=='niri-mac:LaTeX' then absolute={800,500} else ratio={.7,.8} end
  elseif bundle=='com.tencent.qq' then ratio={.7,.8}
  elseif bundle=='org.zotero.zotero' and not title:match('Settings') then ratio={.95,.95}
  elseif bundle=='com.apple.Preview' and title:match('^niri%-mac%-clipboard%-') then ratio={.55,.65} end
  if not ratio and not absolute then return end
  sized[w:id()]=true
  hs.timer.doAfter(.45,function()
    if not w:application() then return end
    local screen=w:screen();if not screen then return end
    local f=screen:frame()
    local width=absolute and math.min(absolute[1],f.w*.95) or f.w*ratio[1]
    local height=absolute and math.min(absolute[2],f.h*.95) or f.h*ratio[2]
    w:setFrame({x=f.x+(f.w-width)/2,y=f.y+(f.h-height)/2,w=width,h=height},0)
  end)
end)
function M.health()
  return {accessibility=hs.accessibilityState(),secureInput=hs.eventtap.isSecureInputEnabled(),scroll=M.scroll:isEnabled(),functionKeys=M.functionKeys:isEnabled(),threeFingerSwipe=M.threeFingerTap:isEnabled(),winSignal=M.winSignal:isEnabled(),winDown=M.winDown,hotkeyCount=#M.hotkeys,failedBindings=M.failedBindings,enabled=M.enabled,login=hs.autoLaunch()}
end
function M.configureMonitors()
  local screens={}
  for _,s in ipairs(hs.screen.allScreens()) do
    local name=s:name();local lower=name:lower()
    local builtin=lower:find('built%-in')~=nil or lower=='color lcd' or name:find('内建')~=nil or name:find('内置')~=nil
    screens[#screens+1]={id=s:id(),name=name,uuid=s:getUUID(),builtIn=builtin,width=s:fullFrame().w}
  end
  run(root..'/bin/configure-monitors.py',{hs.json.encode(screens)},nil,true)
end
M.screenWatcher=hs.screen.watcher.new(function()
  if M.screenTimer then M.screenTimer:stop() end
  M.screenTimer=hs.timer.doAfter(2,M.configureMonitors)
end):start()
M.wakeWatcher=hs.caffeinate.watcher.new(function(event)
  if event==hs.caffeinate.watcher.systemWillSleep then resetMod() end
  if event==hs.caffeinate.watcher.systemDidWake then resetMod();hs.timer.doAfter(4,M.configureMonitors) end
end):start()
M.configureMonitors()
log.i('Loaded '..#M.hotkeys..' companion shortcuts')
