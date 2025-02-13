# move to .zshenv
# ################################################################################################
# if  [[ "$OSTYPE" == "darwin"* ]]; then
#   export PATH=$HOME/.bin:$PATH
#   export PATH=/Library/TeX/texbin:$PATH
#   export PATH="/opt/X11/bin:$PATH"
#   export NVM_DIR="$HOME/.nvm"
#   export DISPLAY=:0
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#   # >>> conda initialize >>>
#   # !! Contents within this block are managed by 'conda init' !!
#   __conda_setup="$('/Users/hanyu_yan/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#   if [ $? -eq 0 ]; then
#       eval "$__conda_setup"
#   else
#       if [ -f "/Users/hanyu_yan/anaconda3/etc/profile.d/conda.sh" ]; then
#           . "/Users/hanyu_yan/anaconda3/etc/profile.d/conda.sh"
#       else
#           export PATH="/Users/hanyu_yan/anaconda3/bin:$PATH"
#       fi
#   fi
#   unset __conda_setup
#   # <<< conda initialize <<<
# ################################################################################################
# elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
#   export TEXMFDIST="/usr/share/texmf-dist"
#   export OBSIDIAN_REST_API_KEY="f7a2d5985263aeb6cf8fa6ba2130ede5a41b61e80943639ca4c088826ead83c3"
#   # Add .NET Core SDK tools
#   export PATH="$PATH:/home/fireond/.dotnet/tools"
#   export PULSE_SERVER=tcp:127.0.0.1:4712
#   source ~/Documents/api_env
#   aurhelper="paru"
#   # >>> conda initialize >>>
#   # !! Contents within this block are managed by 'conda init' !!
#   # __conda_setup="$('/home/fireond/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#   # if [ $? -eq 0 ]; then
#   #     eval "$__conda_setup"
#   # else
#   #     if [ -f "/home/fireond/miniconda3/etc/profile.d/conda.sh" ]; then
#   #         . "/home/fireond/miniconda3/etc/profile.d/conda.sh"
#   #     else
#   #         export PATH="/home/fireond/miniconda3/bin:$PATH"
#   #     fi
#   # fi
#   # unset __conda_setup
#   # <<< conda initialize <<<
# fi
# ################################################################################################


# save history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory


### --- Plugins --- ###
export ZSH=$HOME/.zsh
autoload -U compinit; compinit
source $ZSH/plugins/fzf-tab/fzf-tab.plugin.zsh
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fpath=($ZSH/plugins/zsh-completions/src $fpath)

function a() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


### --- Alias --- ###
if [[ "$OSTYPE" == "darwin"* ]]; then
  pdfviewer="sioyek"
  alias ld='learn ddl'
  alias proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
  alias unproxy='unset all_proxy'
  alias disablesleep='sudo pmset -a disablesleep 1'
  alias enablesleep='sudo pmset -a disablesleep 0'
  alias op='open .'
  alias tt='toggle_alacritty_opacity'
  alias bs='brew search'
  alias bi='brew install'
  alias skim='/Applications/Skim.app/Contents/MacOS/Skim'
  alias cala='nvim ~/.config/alacritty/alacritty.yml'
  alias cyabai='nvim ~/.config/yabai/yabairc'
  alias cyazi='nvim ~/.config/yazi/keymap.toml'
  alias cskhd='nvim ~/.config/skhd/skhdrc'
  alias csket='nvim ~/.config/sketchybar/sketchybarrc'
  alias ckitty='nvim ~/.config/kitty/kitty.conf'
  alias cwez='nvim ~/.config/wezterm/wezterm.lua'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias op='xdg-open'
  alias l='eza -lh --icons=auto' # long list
  alias ls='eza -1 --icons=auto' # short list
  alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
  alias ld='eza -lhD --icons=auto' # long list dirs
  alias lt='eza --icons=auto --tree' # list folder as tree

  alias un='$aurhelper -Rns' # uninstall package
  alias up='$aurhelper -Syu' # update system/package/aur
  alias pf='$aurhelper -Qs' # list installed package
  alias ps='$aurhelper -Ss' # search available package
  alias pi='$aurhelper -S' # install package
  alias pc='$aurhelper -Sc' # remove unused cache
  alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -

  alias ekeyd='sudo systemctl start keyd'
  alias rkeyd='sudo systemctl restart keyd'
  alias skeyd='sudo systemctl stop keyd'
  alias ecrash='sudo systemctl start shellcrash'
  alias rcrash='sudo systemctl restart shellcrash'
  alias scrash='sudo systemctl stop shellcrash'

  alias getbright='ddcutil getvcp 10'
  alias setbright='ddcutil setvcp 10'

  alias openbg='alacritty --class "kitty-bg" -e "/home/fireond/.dotfiles/hyprland/.config/hypr/cavabg.sh"'
  alias hyprcli='hyprctl clients'
  alias hyprmon='hyprctl monitors'
fi

alias c='clear'
alias b='btop'
alias v='~/.local/share/bin/auto_padding_nvim.sh'
alias nvim='~/.local/share/bin/auto_padding_nvim.sh'
alias nv='nohup neovide &'
alias t='tmux'
alias vi='nvim'
alias vf='nvim $(fzf)'
alias m='musicfox'

alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias gcl='git clone'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gac='git commit -am'
alias gps='git push'
alias gpl='git pull'
alias upd='git pull; git add --all; git commit -m "update"; git push'
alias gitlog='git log --all --graph --pretty=format:"%Cred%h%Creset %C(bold blue)%an%Creset %s %Cgreen(%cr) %Creset" --abbrev-commit'
alias gsi='git submodule init'
alias gsu='git submodule update --recursive --remote'
alias lg='lazygit'

alias szsh='source ~/.zshrc'
alias czsh='nvim ~/.zshrc'
alias cbash='nvim ~/.bashrc'
alias sbash='source ~/.bashrc'

alias ca='ipython --profile=calculate'
alias pdf="fd --type f --extension pdf . ~ | fzf | xargs -r -I {} sh -c 'nohup zathura \"{}\" &> /dev/null &'"
alias spdf="fd --type f --extension pdf . ~ | fzf | xargs -r -I {} sh -c 'nohup sioyek \"{}\" &> /dev/null &'"


# conda alias
alias ai='conda activate ai'
alias condab='conda activate base'
alias qcx='conda activate QCX'
alias qtp='conda activate qutip-env'
alias condal='conda env list'

eval "$(zoxide init zsh)"
# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

# Created by `pipx` on 2025-02-09 13:06:45
export PATH="$PATH:/home/fireond/.local/bin"
