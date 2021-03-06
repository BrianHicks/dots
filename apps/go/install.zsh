#!/usr/bin/env szh
brew-install go --cross-compile-all
brew-install glide
unstow-app go
directory ~/code/go

# install go libraries
source apps/go/.zshenv.d/go.zsh

for package in github.com/mitchellh/gox \
               github.com/nsf/gocode \
               github.com/rogpeppe/godef \
               golang.org/x/tools/cmd/benchcmp \
               golang.org/x/tools/cmd/callgraph \
               golang.org/x/tools/cmd/cover \
               golang.org/x/tools/cmd/eg \
               golang.org/x/tools/cmd/godoc \
               golang.org/x/tools/cmd/goimports \
               golang.org/x/tools/cmd/gorename \
               golang.org/x/tools/cmd/gotype \
               golang.org/x/tools/cmd/oracle \
               ; do
    if [ -n "$UPDATE" ] || [ ! -d $GOPATH/src/$package ]; then
       echo installing/updating $package
       go get -u $package
    else
        echo $package already installed
    fi
done
