# 创建Neovim配置目录与配置`lazy.nvim`

## 使用`stow`来管理配置文件
- 下载（使用`brew`）
```shell
brew install stow
```
- 创建配置文件夹
```shell
mkdir ~/.dotfiles
```
- 创建`nvim`的配置文件夹
```shell
mkdir -p ~/.dotfiles/YourConfigName/.config/nvim
```
- 创建链接：
```shell
stow YourConfigName
```
其作用相当于将`YourConfigName`下的所有文件放置于主目录`.dotfiles`的父级目录`~`（也就是家目录）中，也就是创建了`~/.config/nvim`。
可将其余配置文件均利用此方法放置于`.dotfiles`中，从而只利用一个仓库管理

## Neovim文件结构
```
fvim
└── .config
    └── nvim
        ├── init.lua
        └── lua
            ├── config
            │   ├── autocmds.lua
            │   ├── keymaps.lua
            │   ├── lazy.lua
            │   └── options.lua
            ├── plugins
            └── utils
```
其中`init.lua`是Neovim配置的入口，所有操作都从它开始。`lua/`是默认的`run time path`之一，可以直接调用其中的模块。

## `init.lua`的配置
```lua
require("config.options")
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds")
		require("config.keymaps")
	end,
})
```
前两行是调用`lua/config`中的`options.lua`和`lazy.lua`（注意不需要后缀名，且默认路径为`lua/`）
之后调用`vim.api.nvim_create_autocmd()`函数，执行`autocmds`，懒启动`lua/config`中的`autocmds.lua`和`keymaps.lua`

**注意`require`前首先需要创建相应的文件夹**

## 配置`lazy.nvim`
```lua
-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- bootstrap lazy.nvim
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  }
	defaults = { lazy = true, version = false }, -- always use the latest git commit
	install = { colorscheme = { "tokyonight", "gruvbox" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
        "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
```
前半部分是安装`lazy.nvim`，后半部分是简单的配置`lazy.nvim`
