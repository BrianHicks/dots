# load all files from ~/.zshenv.d
export fpath=($HOME/.zsh.funcs $fpath)

export GPG_TTY=$(tty)

if [[ -d $HOME/.zshenv.d ]]; then
    for file in $HOME/.zshenv.d/*.zsh; do
        source $file
    done

    for file in $HOME/.zshenv.d/*.zsh.gpg; do
        eval "$(/usr/local/bin/gpg -d -quiet --no-tty < $file)"
    done
fi
