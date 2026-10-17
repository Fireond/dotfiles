-- One three-finger stroke = one OmniWM action, matching Option+H/J/K/L.
-- Uses Hammerspoon's documented NSTouch fields; no private multitouch module.
return function(onSwipe)
  local G={devices={},stats={frames=0,threeFingerFrames=0,left=0,right=0,up=0,down=0,scrollSuppressed=0}}
  function G:reset() self.devices={};self.eatMomentum=false end
  function G:consumeScroll(now,momentum)
    for _,s in pairs(self.devices) do
      if s.claimed and now-s.lastSeen<0.2 then
        self.eatMomentum=true
        self.stats.scrollSuppressed=self.stats.scrollSuppressed+1
        return true
      end
    end
    if momentum and self.eatMomentum then
      self.stats.scrollSuppressed=self.stats.scrollSuppressed+1
      return true
    end
    if not momentum then self.eatMomentum=false end
    return false
  end
  function G:process(touches,now)
    now=now or os.clock()
    self.stats.frames=self.stats.frames+1
    -- macOS interleaves empty gesture packets while fingers are still moving.
    -- They are not a lift: retain the origin and the once-per-stroke latch.
    if not touches or #touches==0 then return false end
    local groups={}
    for _,t in ipairs(touches) do
      if t.type=='indirect' then
        local device=t.device or 'trackpad'
        groups[device]=groups[device] or {}
        if t.touching and not t.resting and t.normalizedPosition then
          table.insert(groups[device],t)
        end
      end
    end
    local consume=false
    for device,active in pairs(groups) do
      local n=#active
      local ids,contacts={},{}
      for _,t in ipairs(active) do
        local id=tostring(t.identity);ids[#ids+1]=id;contacts[id]=true
      end
      table.sort(ids);local identity=table.concat(ids,'|')
      local s=self.devices[device]
      local overlap=false
      if s then for id in pairs(contacts) do if s.contacts[id] then overlap=true;break end end end
      if not s or now-s.lastSeen>0.3 or (n>0 and not overlap) then
        s={};self.devices[device]=s;self.eatMomentum=false
      end
      s.contacts=contacts;s.lastSeen=now
      if n==0 then self.devices[device]=nil
      elseif n>3 then
        -- Four-finger Spaces and Mission Control remain native.
        s.blocked=true;s.claimed=false;self.eatMomentum=false
      elseif n<3 then
        s.origin=nil
        consume=consume or s.fired or false
      else
        self.stats.threeFingerFrames=self.stats.threeFingerFrames+1
        local x,y=0,0
        for _,t in ipairs(active) do
          x=x+t.normalizedPosition.x;y=y+t.normalizedPosition.y
        end
        x=x/3;y=y/3
        if not s.blocked then s.claimed=true end
        if not s.blocked and not s.fired then
          if not s.origin or s.identity~=identity then
            s.origin={x=x,y=y};s.identity=identity
          else
            local dx,dy=x-s.origin.x,y-s.origin.y
            local direction
            if math.abs(dy)>=0.08 and math.abs(dy)>math.abs(dx)*1.4 then
              -- NSTouch's origin is bottom-left: upward fingers mean positive dy.
              -- Upward swipe -> J (down); downward swipe -> K (up).
              direction=dy>0 and 'down' or 'up'
            elseif math.abs(dx)>=0.08 and math.abs(dx)>math.abs(dy)*1.4 then
              direction=dx<0 and 'right' or 'left'
            end
            if direction then
              s.fired=true
              self.stats[direction]=self.stats[direction]+1
              self.stats.lastDirection=direction
              onSwipe(direction)
            end
          end
        end
        consume=consume or s.claimed or false
      end
    end
    return consume
  end
  return G
end
