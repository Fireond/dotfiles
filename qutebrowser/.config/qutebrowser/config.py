import catppuccin

config.load_autoconfig(False)
config.source("keymap.py")

c.auto_save.session = True
catppuccin.setup(c, "macchiato", True)

c.fonts.web.family.standard = "WenQuanYi Micro Hei"
c.fonts.web.family.serif = "WenQuanYi Micro Hei"
c.fonts.web.size.default = 14
c.fonts.web.size.default_fixed = 14
c.tabs.position = "left"
c.tabs.width = 150

c.downloads.remove_finished = 3000


c.editor.command = [
    "kitty",
    "--single-instance",
    "-d",
    "~",
    "-e",
    "auto_padding_nvim.sh",
    "-f",
    "{file}",
    "-c",
    "normal {line}G{column0}l",
]

c.content.headers.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:141.0) Gecko/20100101 Firefox/141.0"
c.content.javascript.clipboard = "access-paste"
c.hints.padding = {"bottom": 1, "left": 5, "right": 3, "top": 1}
c.hints.border = "none"
c.hints.selectors["all"].extend([".qutebrowser-custom-hint"])

c.scrolling.bar = "always"
c.scrolling.smooth = True

c.statusbar.widgets = ["search_match", "text:|", "url", "text:|", "scroll"]

c.tabs.padding = {"bottom": 3, "left": 5, "right": 5, "top": 3}


c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "wk": "https://en.wikipedia.org/w/index.php?search={}",
    "gt": "https://github.com/search?q={}",
    "zh": "https://www.zhihu.com/search?q={}&type=content",
    "bl": "https://search.bilibili.com/all?keyword={}",
}
