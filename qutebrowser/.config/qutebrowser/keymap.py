unbinds = ["d", "H", "J", "K", "L"]

quick_binds = {
    "c": "https://chatgpt.com",
    "g": "https://github.com",
    "b": "https://bilibili.com",
    "z": "https://zhihu.com",
    "i": "https://info.tsinghua.edu.cn",
    "l": "https://login.tsinghua.edu.cn",
}

keybinds = {
    "<Ctrl-Alt-c>": "config-cycle tabs.show always never",
    "<Space>j": "tab-next",
    "<Space>k": "tab-prev",
    "<Alt-h>": "tab-prev",
    "<Alt-l>": "tab-next",
    "<Alt-0>": "tab-focus -1",
    "<Ctrl-h>": "back",
    "<Ctrl-l>": "forward",
    "<Ctrl-d>": "cmd-run-with-count 15 scroll down",
    "<Ctrl-u>": "cmd-run-with-count 15 scroll up",
    "<Space>D": "tab-close",
    "<Ctrl-f>": "hint all hover",
    "cs": "config-source",
    "<Space><Space>": "click-element --force-event id qb-ghost",
}

for unbind in unbinds:
    config.unbind(unbind)

for k, url in keybinds.items():
    config.bind(k, url)

for k, url in quick_binds.items():
    config.bind(f"<Space>g{k}", f"open -t {url}")
