#!/usr/bin/env zsh
source ~/.zsh_extensions/zsh-history-substring-search/zsh-history-substring-search.zsh

# Apple MacBook + iTerm option from https://github.com/zsh-users/zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down
