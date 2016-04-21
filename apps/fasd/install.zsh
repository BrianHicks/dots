#!/usr/bin/env zsh
brew-install fasd
unstow-app fasd

echo '#!/usr/bin/env zsh' > ~/.zshrc.d/fasd.zsh
fasd --init auto >> ~/.zshrc.d/fasd.zsh
