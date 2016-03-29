#!/usr/bin/env zsh
brew-install pyenv
unstow-app python
directory $HOME/wheelhouse

python_version=2.7.11
if pyenv version | grep -q $python_version; then
    echo Python $python_version is already installed
else
    echo installing Python $python_version
    pyenv install $python_version
fi

if grep -q $python_version ~/.pyenv/version; then
    echo global Python already set to $python_version
else
    echo setting global Python to $python_version
    pyenv global $python_version
fi
