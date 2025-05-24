#!/usr/bin/env zsh

# 获取壁纸路径
wallpaper="$1"

matugen image "$wallpaper"

# # 使用 ImageMagick 检测图片的平均亮度
# brightness=$(magick "$wallpaper" -colorspace Gray -format "%[fx:mean]" info:)
#
# # 设置亮度阈值，根据实际情况调整
# threshold=0.7
#
# # 比较亮度并选择主题
# if (($(echo "$brightness > $threshold" | bc -l))); then
#   # 图片较亮，应用亮色主题
#   matugen image "$wallpaper" -m light
#   gsettings set org.gnome.desktop.interface color-scheme prefer-light
#   theme="Light Theme"
# else
#   # 图片较暗，应用暗色主题
#   matugen image "$wallpaper"
#   gsettings set org.gnome.desktop.interface color-scheme prefer-dark
#   theme="Dark Theme"
# fi
#
# # 发送桌面通知
# notify-send "主题已切换" "当前主题模式: $theme" --icon="$HOME/.config/waypaper/scripts/icon.svg"
