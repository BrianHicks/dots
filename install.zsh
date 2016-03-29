#!/usr/bin/env zsh
HERE=~/zish

fpath=($HERE/apps/zish/.zsh.funcs)

autoload unstow-app brew-install

# basic utilities needed for the rest of the installation
brew-install stow
brew-install zsh-syntax-highlighting

unstow-app zsh

## GRC ##
brew-install grc
unstow-app grc
