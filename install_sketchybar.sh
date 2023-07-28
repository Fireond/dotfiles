#!/bin/bash

# install sketchybar

brew tap FelixKratz/formulae
brew install sketchybar

# install dependencies

brew install --cask sf-symbols
brew install jq
brew install switchaudio-osx
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.4/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# clone config

svn export https://github.com/Fireond/dotfiles.git/trunk/sketchybar/.config/sketchybar ~/.config/sketchybar

# start sketchybar

brew services start sketchybar
