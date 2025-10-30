import catppuccin

config.load_autoconfig()

c.auto_save.session = True
catppuccin.setup(c, "macchiato", True)

c.fonts.web.family.standard = "WenQuanYi Micro Hei"
c.fonts.web.family.serif = "WenQuanYi Micro Hei"
c.fonts.web.size.default = 14
c.fonts.web.size.default_fixed = 14


c.tabs.position = "left"
c.tabs.width = 150

c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "wk": "https://en.wikipedia.org/w/index.php?search={}",
    "gt": "https://github.com/search?q={}",
    "zh": "https://www.zhihu.com/search?q={}&type=content",
    "bl": "https://search.bilibili.com/all?keyword={}",
}


# keybinds
config.bind(",c", "open -t https://chatgpt.com")
config.bind(",b", "open -t https://bilibili.com")
config.bind(",z", "open -t https://zhihu.com")
config.bind(",i", "open -t https://info.tsinghua.edu.cn")
config.bind(",l", "open -t https://login.tsinghua.edu.cn")

config.bind("<Ctrl-Alt-c>", "config-cycle tabs.show always never")
