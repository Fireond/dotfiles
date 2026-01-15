# nbpreview.yazi

View your Jupyter notebooks beautifully in the preview in Yazi.

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) version >=25.4.8
- [nbpreview](https://github.com/paw-lu/nbpreview)

## Previews

<img width="1416" alt="image" src="https://github.com/AnirudhG07/nbpreview.yazi/assets/146579014/87535dc9-c45a-4eb7-a732-4384460b516d">

## Installation

```bash
ya pkg add AnirudhG07/nbpreview

## For linux and MacOS
git clone https://github.com/AnirudhG07/nbpreview.yazi.git ~/.config/yazi/plugins/nbpreview.yazi

## For Windows
git clone https://github.com/AnirudhG07/nbpreview.yazi.git %AppData%\yazi\config\plugins\nbpreview.yazi
```

## Usage

After installing the plugin, add this to your `yazi.toml` file inside the plugin's section previously present.

```toml
[plugin]
prepend_previewers = [
  { name = "*.ipynb", run = "nbpreview" },
]
```

## Configurations

You can configure your preview by editing the `init.lua` file present in the plugin directory.
<img width="724" alt="image" src="https://github.com/AnirudhG07/nbpreview.yazi/assets/146579014/99405d1f-3de8-4beb-a581-4a41affe8e57">

All the configurations provided using `nbpreview --help`.
By default we have give you some of the flags which you can change according to your needs in the `init.lua` file.

Please DONOT change the below options(unless you know what you are doing) -

- `--nerd-font` - Yazi uses nerd-font.
- \*`--decorated` - This enables the decorations you see in the preview.
- `--no-paging` - To avoid errors.

The `OPTIONAL CHANGES` flags are by default(recommended) given. You can add more or change as you wish.

## CUSTOMIZATION

You can Color customize your previews from the Color schemes and themes provided by `nbpreview`. These are -

```bash
# COLOR SCHEMES
--color-system, --cs [standard|256|truecolor|windows|none|auto]
                The type of color system to use.  [env var: NBPREVIEW_COLOR_SYSTEM]

# THEMES
  -t, --theme [abap|algol|algol_nu|arduino|autumn|bw|borland|coffee|colorful|default|
            dracula|emacs|friendly_grayscale|friendly|fruity|github-dark|gruvbox-dark|
            gruvbox-light|igor|inkpot|lightbulb|lilypond|lovelace|manni|material|monokai|
            murphy|native|nord-darker|nord|one-dark|paraiso-dark|paraiso-light|pastie|
            perldoc|rainbow_dash|rrt|sas|solarized-dark|solarized-light|staroffice|stata-dark|
            stata-light|tango|trac|vim|vs|xcode|zenburn|light|dark|ansi_light|ansi_dark]
```

You can change the default give color scheme and theme to any you like.

> [!Note]
>
> The loading of `ipynb` might appear slow. This is due to the lag created by the command itself and not because of the plugin or yazi

## Using piper.yazi

[piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) is a general-purpose previewer - you can pass any shell command to piper and it will use the command's output as the preview content.

To use `nbpreview` with piper, you can add this in your `yazi.toml` file:

```toml
[[plugin.prepend_previewers]]
name = "*.ipynb"
run  = 'piper -- nbpreview --no-paging --nerd-font --decorated --no-files --unicode --color --images --color-system=standard --theme=ansi_dark "$1"'
```

## Explore Yazi

Yazi is an amazing, blazing fast terminal file manager, with a variety of plugins, flavors and themes. Check them out at [awesome-yazi](https://github.com/AnirudhG07/awesome-yazi) and the official [yazi webpage](https://yazi-rs.github.io/).
