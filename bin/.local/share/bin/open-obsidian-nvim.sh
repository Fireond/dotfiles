#!/bin/zsh
session_name="${HOME//\//\\%}\%Documents\%sync-server\%Obsidian-Vault.vim"
exec kitty -e "$HOME/.local/share/bin/auto_padding_nvim.sh" -S "$HOME/.local/state/nvim/sessions/$session_name"
# exec kitty -e /home/fireond/.local/share/bin/auto_padding_nvim.sh -S "/home/fireond/.local/state/nvim/sessions/\%home\%fireond\%Documents\%sync-server\%Obsidian-Vault.vim"
