#!/bin/bash

mkdir -p $HOME/.local
git clone https://github.com/burke/minidev.git $HOME/.local/minidev
  
install_bash_shell_shim() {
  local bp
  bp="${HOME}/.bash_profile"

  # If the user doesn't already have a .bash_profile, this is kind of complex:
  # The order of preference for login shell config files is:
  # .bash_profile -> .bash_login -> .profile
  # If we create a higher precedence one, the lower is masked.
  # Additionally, .bashrc is loaded for non-login shells and .bash_profile isn't.
  # So what we will do is create .bash_profile which will:
  # 1. Source .bash_login if it exists
  # 2. Source .profile if is exists and .bash_login did not
  # 4. Source dev.sh
  #
  # And additionally, we will append to .bashrc which will load dev if it exists
  # and the shell is also interactive.
  #
  # See:
  # * http://howtolamp.com/articles/difference-between-login-and-non-login-shell/
  # * http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_01.html

  if [[ -f "${bp}" ]]; then
    : # nothing to add to .bash_profile at this stage.
  elif [[ -f "${HOME}/.bash_login" ]]; then
    echo "source ~/.bash_login" >> "${bp}"
  elif [[ -f "${HOME}/.profile" ]]; then
    echo "source ~/.profile" >> "${bp}"
  fi

  if grep -q "minidev/dev.sh" "${bp}" 2>/dev/null; then
    echo "bash_profile already set up for minidev"
  else
    cat << 'EOF' >> "${bp}"

if [[ ! -f /opt/dev/dev.sh && -f "$HOME/.local/minidev/dev.sh" ]]; then
  source "$HOME/.local/minidev/dev.sh"
fi
EOF
    echo "added lines to the end of ~/.bash_profile"
  fi

  if grep -q "minidev/dev.sh" "${HOME}/.bashrc" 2>/dev/null; then
    echo "bashrc already set up for minidev"
  else
    cat << 'EOF' >> "${HOME}/.bashrc"

# load minidev, but only if present and the shell is interactive
if [[ ! -f /opt/dev/dev.sh && -f "${HOME}/.local/minidev/dev.sh" && $- == *i* ]]; then
  source "${HOME}/.local/minidev/dev.sh"
fi
EOF
    echo "added lines to the end of ~/.bashrc"
  fi
}

install_zsh_shell_shim() {
  local rcfile
  rcfile="${HOME}/.zshrc"
  touch "${rcfile}"
  if grep -q minidev/dev.sh "${rcfile}"; then
    echo "zsh already set up for minidev"
    return
  fi
  cat << 'EOF' >> "${rcfile}"

if [[ ! -f /opt/dev/dev.sh && -f "${HOME}/.local/minidev/dev.sh" ]]; then
  source "${HOME}/.local/minidev/dev.sh"
fi
EOF
  echo "added lines to the end of ${rcfile}"
}

case "$(uname -s)" in
  Darwin)
    mac=1
    shell="$(dscl . -read "/Users/$(whoami)" UserShell | awk '{print $NF}')"
    ;;
  Linux)
    linux=1
    shell="$(getent passwd "$(whoami)" | cut -d: -f7)"
    ;;
  *)
    echo "Unsupported platform!" >&2
    exit 1
    ;;
esac

case "${SHELL:-${shell}}" in
  */bash|bash)
    install_bash_shell_shim
    ;;
  */zsh|zsh)
    # Pretty much every zsh user just uses ~/.zshrc so we won't worry about
    # all that file detection stuff we do with bash.
    install_zsh_shell_shim
    ;;
  *)
    >&2 echo "minidev is not supported on your shell (${shell} -- bash and zsh are supported)."
    exit 1
    ;;
esac

# if you are in a devcontainer and it follows the /workspaces convention let's set that as your goto
if [ -d /workspaces ]; then
  . "$HOME/.local/minidev/dev.sh"
  dev config set default.github_root /workspaces
fi