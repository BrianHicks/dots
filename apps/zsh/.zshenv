# load all files from ~/.zshenv.d
export fpath=($HOME/.zsh.funcs $fpath)

if [[ -d $HOME/.zshenv.d ]]; then
    for file in $HOME/.zshenv.d/*.zsh; do
        source $file
    done

    for file in $HOME/.zshenv.d/*.zsh.gpg; do
        eval "$(gpg -d -quiet --no-tty < $file)"
    done
fi
