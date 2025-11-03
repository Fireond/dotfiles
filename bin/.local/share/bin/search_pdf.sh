#!/usr/bin/env bash

fd --type f --extension pdf . ~ | fzf | xargs -r -I {} sh -c "nohup zathura \"{}\" &> /dev/null &"
# fd --type f --extension pdf . ~ | fzf | xargs -r -I {} sh -c "nohup zathura \"{}\" &"
