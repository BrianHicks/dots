# load all files from ~/.zshenv.d
export fpath=($HOME/.zsh.funcs $fpath)

if [[ -d $HOME/.zshenv.d ]]; then
    for file in $HOME/.zshenv.d/*; do
        source $file
    done
fi
