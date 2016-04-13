#!/usr/bin/env zsh
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.zsh_history"

# ignore dups and lines starting with space
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_expire_dups_first

# I've set this instead of inc_append_history because I prefer my shells to have
# a local history that is shared, but have their own history isolated until
# exit.
setopt append_history
