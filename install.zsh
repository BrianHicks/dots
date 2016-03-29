#!/usr/bin/env zsh
fpath=($PWD/apps/zish/.zsh.funcs)

autoload unstow-app brew-install

# basic utilities needed for the rest of the installation
brew-install stow

for app in apps/*; do
    echo
    echo "### $(basename $app) ###"
    if [ -f $app/install.zsh ]; then
        eval "$(cat $app/install.zsh)"
    else
        echo "app does not have install.sh, skipping"
    fi
done
