# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Ensure the cask keg and recipe are installed.
kegs=(
  homebrew/cask-versions
  homebrew/cask-fonts
  )
brew_tap_kegs

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# adobe-creative-cloud      cleanmymac      google-chrome       launchrocket    skype         transmit
# alfred          colorpicker-skalacolor  google-drive        mongohub (!)    sourcetree        tvshows
# appcleaner        dropbox     gopro-studio        onepassword (!)   spectacle       vagrant
# bartender       evernote      imageoptim        path-finder     sublime-text3       virtualbox
# caffeine        fantastical     java7         quicklook-csv   synergy         virtualhostx
# charles         firefox     jing          radiant-player    teamviewer        viscosity
# chromium        flash     kaleidoscope        remote-desktop-connection totals2         vlc
# clamxav         github      ksdiff          sequel-pro      transmission        xscope
# betterzipql
# Color pickers
# colorpicker-developer
# suspicious-package
# tvshows
# webp-quicklook
#android-file-transfer
#android-platform-tools
#android-sdk
#appcleaner
#cornerstone
#dash
#charles
#fastscripts
#google-drive-file-stream
#waltr
#xquartz
#gyazo
#launchbar
#midi-monitor
#hermes
#ynab
#qlcolorcode
#qlmarkdown
#qlprettypatch
#qlstephen
#webpquicklook
#omnidisksweeper
#reaper
#chromium


#battle-net
#bettertouchtool
#codekit
#colorpicker-skalacolor
#growlnotify
#handbrake
#java
#ssh-tunnel-manager
#transmission
#quicklook-json
#quicknfo


# Homebrew casks
casks=(
  1password
  1password-cli
  a-better-finder-rename
  alfred
  atom
  bartender
  docker
  divvy
  dropbox
  fantastical
  firefox
  font-mplus
  font-mplus-nerd-font
  font-sauce-code-pro-nerd-font
  font-source-code-pro
  font-source-code-pro-for-powerline
  github
  gpg-suite
  hex-fiend
  imageoptim
  intellij-idea
  iterm2
  kaleidoscope
  keepingyouawake
  keybase
  macdown
  macvim
  postman
  resilio-sync
  sourcetree
  spotify
  sublime-text
  suspicious-package
  teamviewer
  the-unarchiver
  toggl-track
  transmit
  vagrant
  vagrant-manager
  virtualbox
  viscosity
  visual-studio-code
  vlc
  whatsapp
  xscope

  # Quick Look plugins
  qlcolorcode
  qlmarkdown
  qlprettypatch
  qlstephen
  quicklook-csv
  quicklook-json
  quicknfo
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew install --cask $cask
  done
  brew cleanup
fi
