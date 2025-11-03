#!/bin/bash

hyprctl dispatch exec "[workspace 1] zen"
# hyprctl dispatch exec "[workspace 9] kitty --class='musicfox' -e bash -c 'tmux new -s musicfox -d \"musicfox\" && tmux split-window -h -p 40 -t musicfox \"cava\" && tmux attach -t musicfox'"
# hyprctl dispatch exec "[workspace 3] kitty --class='write' -e bash -c 'tmux new-session -d -s write && tmux send-keys -t write.1 \"z obs\" ENTER \"neovide &\" && tmux attach -t write'"
hyprctl dispatch exec "[workspace 9] kitty --class='musicfox' -e bash -c 'musicfox'"
# hyprctl dispatch exec "[workspace 3] neovide --wayland_app_id=write"
