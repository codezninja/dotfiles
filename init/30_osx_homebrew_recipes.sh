# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

kegs=(
  liamg/tfsec
  hashicorp/tap
  )
brew_tap_kegs

# Homebrew recipes
recipes=(
  awscli
  bash
  cmatrix
  consul
  consul-template
  container-diff
  coreutils
  cowsay
  envconsul
  ffmpeg
  fontconfig
  fontforge
  freetype
  gawk
  gh
  git
  git-extras
  glib
  go
  gobject-introspection
  gpg2
  gradle
  hashicorp/tap/waypoint
  imagemagick
  jenv
  jpeg
  jq
  lesspipe
  libevent
  libffi
  libpng
  libsodium
  libtiff
  libtool
  libvo-aacenc
  libxml2
  libyaml
  maven
  mysql-client
  nave
  openssl
  packer
  pre-commit
  python3
  rbenv/tap/openssl@1.0
  readline
  reattach-to-user-namespace
  session-manager-plugin
  subversion
  terminal-notifier
  terraform-docs
  tfenv
  tflint
  tfsec
  tmux
  tree
  unar
  unixodbc
  vault
  vim
  wget
  x264
  xvid
  xz
  zlib
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# bash
if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
  e_header "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Making $binroot/bash your default shell"
  sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi
