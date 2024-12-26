################################################################################################
if  [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=$HOME/.bin:$PATH
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
################################################################################################
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export TEXMFDIST="/usr/share/texmf-dist"
  # In case a command is not found, try to find the package that has it
  function command_not_found_handler {
      local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
      printf 'zsh: command not found: %s\n' "$1"
      local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
      if (( ${#entries[@]} )) ; then
          printf "${bright}$1${reset} may be found in the following packages:\n"
          local pkg
          for entry in "${entries[@]}" ; do
              local fields=( ${(0)entry} )
              if [[ "$pkg" != "${fields[2]}" ]]; then
                  printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
              fi
              printf '    /%s\n' "${fields[4]}"
              pkg="${fields[2]}"
          done
      fi
      return 127
  }

  aurhelper="paru"
  function in {
      local -a inPkg=("$@")
      local -a arch=()
      local -a aur=()

      for pkg in "${inPkg[@]}"; do
          if pacman -Si "${pkg}" &>/dev/null; then
              arch+=("${pkg}")
          else
              aur+=("${pkg}")
          fi
      done

      if [[ ${#arch[@]} -gt 0 ]]; then
          sudo pacman -S "${arch[@]}"
      fi

      if [[ ${#aur[@]} -gt 0 ]]; then
          ${aurhelper} -S "${aur[@]}"
      fi
  }
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/home/fireond/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/home/fireond/miniconda3/etc/profile.d/conda.sh" ]; then
          . "/home/fireond/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="/home/fireond/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
fi
################################################################################################


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
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
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
fi

alias c='clear'
alias v='nvim'
alias vi='nvim'
alias vf='nvim $(fzf)'

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
