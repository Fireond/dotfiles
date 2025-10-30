import catppuccin

config.load_autoconfig()

c.auto_save.session = True
catppuccin.setup(c, "macchiato", True)

# c.fonts.default_family = "WenQuanYi Micro Hei"
# c.fonts.default_size = "14pt"
c.fonts.web.family.standard = "WenQuanYi Micro Hei"
c.fonts.web.family.serif = "WenQuanYi Micro Hei"
c.fonts.web.size.default = 14
c.fonts.web.size.default_fixed = 14

# keybinds
config.bind(",c", "open -t https://chatgpt.com")
config.bind(",b", "open -t https://bilibili.com")
