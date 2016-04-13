#!/usr/bin/env zsh
fpath=($PWD/apps/zish/.zsh.funcs)

# check out submodules
git submodule init

autoload unstow-app brew-install directory

# basic utilities needed for the rest of the installation
brew-install stow

# system
directory ~/code

for app in apps/*; do
    echo
    echo "### $(basename $app) ###"

    # run installation script
    if [ -f $app/install.zsh ]; then
        eval "$(cat $app/install.zsh)"
    else
        echo "app does not have install.sh, skipping"
        continue
    fi

    # install funcs
    if [ -d $app/.zsh.funcs ]; then
        fname=~/.zshrc.d/$(basename $app)-funcs.zsh
        echo "#!/usr/bin/env zsh" > $fname
        for func in $app/.zsh.funcs/*; do
            echo "autoload $(basename $func)" >> $fname
        done

        echo "installed funcs for $(basename $app)"
    fi
done
