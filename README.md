# dotfiles

## SketchyBar Setup

Reference Configurations: https://github.com/ColaMint/config/tree/main/sketchybar, https://github.com/FelixKratz/dotfiles/tree/e6288b3f4220ca1ac64a68e60fced2d4c3e3e20b

**one-click installation**
```bash
./install_sketchybar.sh
```

Use `sf-symbols`, `jq`, `switchaudio-osx`(for audio device switching context menu), [sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font):
```bash
brew install --cask sf-symbols
brew install jq
brew install switchaudio-osx
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.4/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
```

(Optional) If you use yabai (if not just remove `yabai` item from `ìtems/front_app.sh`), add yabai events:
```bash
# signal with sketchybar
yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
```
and skhd shortcuts:
```bash
shift + alt - f : yabai -m window --toggle float; sketchybar --trigger window_focus
shift + alt - m : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus
shift + alt - n : yabai -m space --create; sketchybar --trigger window_focus
shift + alt - d : yabai -m space --destroy; sketchybar --trigger window_focus
shift + alt - 1 : yabai -m window --space 1 && sketchybar --trigger windows_on_spaces
```
