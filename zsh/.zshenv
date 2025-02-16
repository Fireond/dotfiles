if  [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=$HOME/.bin:$PATH
  export PATH=/Library/TeX/texbin:$PATH
  export PATH="/opt/X11/bin:$PATH"
  export NVM_DIR="$HOME/.nvm"
  export DISPLAY=:0
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
  # export PULSE_SERVER=tcp:127.0.0.1:4712
  source ~/Documents/api_env
  aurhelper="paru"
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  # __conda_setup="$('/home/fireond/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  # if [ $? -eq 0 ]; then
  #     eval "$__conda_setup"
  # else
  #     if [ -f "/home/fireond/miniconda3/etc/profile.d/conda.sh" ]; then
  #         . "/home/fireond/miniconda3/etc/profile.d/conda.sh"
  #     else
  #         export PATH="/home/fireond/miniconda3/bin:$PATH"
  #     fi
  # fi
  # unset __conda_setup
  # <<< conda initialize <<<
fi
################################################################################################
