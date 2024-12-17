export ZSH=$HOME/.zsh
## In order to use the executable scripts inside ~/bin directly
export PATH=$HOME/.bin:$PATH


if  [[ "$OSTYPE" == "darwin"* ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/Users/hanyu_yan/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/Users/hanyu_yan/anaconda3/etc/profile.d/conda.sh" ]; then
          . "/Users/hanyu_yan/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="/Users/hanyu_yan/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
fi


### --- Plugins --- ###
source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZSH/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fpath=($ZSH/plugins/zsh-completions/src $fpath)
# eval "$(lua $ZSH/plugins/z.lua/z.lua  --init zsh once enhanced)"

### --- Plugins Config --- ###
# function j() {
#   if [[ "$argv[1]" == "-"* ]]; then
#       z "$@"
#   else
#       cd "$@" 2> /dev/null || z "$@"
#   fi
# }

function a() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


### --- Alias --- ###
alias ld='learn ddl'
alias proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
alias unproxy='unset all_proxy'
alias disablesleep='sudo pmset -a disablesleep 1'
alias enablesleep='sudo pmset -a disablesleep 0'
alias op='open .'
function pdf() {
    sioyek "$1" &
}
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

alias c='clear'
alias lg='l | grep'
alias vi='nvim'
alias v='nvim'
alias vf='nvim $(fzf)'

alias g='git'
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
alias gsu='git submodule update --remote'
alias gsi='git submodule init'

alias szsh='source ~/.zshrc'
alias czsh='nvim ~/.zshrc'

alias ca='ipython --profile=calculate'

alias ai='conda activate ai'
alias qcx='conda activate QCX'



eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
