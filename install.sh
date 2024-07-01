#!/bin/bash

mkdir -p $HOME/.local
git clone https://github.com/burke/minidev.git $HOME/.local/minidev
echo ". $HOME/.local/minidev/dev.sh" >> $HOME/.profile

# if you are in a devcontainer and it follows the /workspaces convention let's set that as your goto
if [ -d /workspaces ]; then
  . "$HOME/.local/minidev/dev.sh"
  dev config set default.github_root /workspaces
fi
