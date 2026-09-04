tap "buo/cask-upgrade"

###############################################################################
# CLI tools                                                                   #
###############################################################################
brew "bash"
brew "bat"
brew "coreutils"          # GNU coreutils (gls, gdate, etc.)
brew "ffmpeg"
brew "glib"
brew "imagemagick"
brew "mas"
brew "ripgrep"
brew "rpm"
brew "snapcraft"
brew "starship"
brew "trash"
brew "wget"
brew "zlib"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "zsh-syntax-highlighting"

# Agent / dev workflow essentials
brew "gh"                 # GitHub CLI — needed for private repos & PR automation
brew "git-lfs"            # .gitconfig sets [filter "lfs"] required = true
brew "tmux"               # .tmux.conf ships in home/ but tmux was never installed
brew "jq"                 # JSON wrangling in scripts/agents
brew "fd"                 # fast find, pairs with ripgrep
brew "fzf"                # fuzzy finder

###############################################################################
# Hardware / embedded                                                         #
###############################################################################

# Serial / UART — talking to boards over USB
brew "minicom"
brew "picocom"
brew "screen"             # newer than the macOS built-in
brew "libusb"

# Microcontrollers
brew "esptool"            # ESP8266 / ESP32 flashing
brew "arduino-cli"
brew "platformio"
brew "avrdude"            # AVR programmer
brew "open-ocd"           # JTAG/SWD debugging (formula is open-ocd, not openocd)

# Embedded / imaging support
brew "dtc"                # device tree compiler (Raspberry Pi overlays)
brew "xz"                 # decompressing .img.xz OS images

###############################################################################
# Cask apps                                                                   #
###############################################################################
cask "visual-studio-code"
# cask "angry-ip-scanner"   # DISABLED upstream 2026-09-01: fails macOS Gatekeeper.
#                          # LAN scanning alternative: `brew install nmap`
cask "cursor"
cask "cyberduck"
cask "docker-desktop"     # renamed upstream — the old "docker" cask is gone
cask "firefox"
cask "ghostty"
cask "google-chrome"
cask "gimp"
# cask "inkscape"
cask "ngrok"
# cask "postman"
cask "slack"
cask "spotify"
cask "transmission"
# cask "unetbootin"        # DISABLED upstream 2026-09-01: fails macOS Gatekeeper.
#                          # balenaetcher + raspberry-pi-imager below cover USB/SD imaging
# cask "vagrant"
cask "vlc"
cask "virtualbox"
cask "warp"
cask "xquartz"
cask "zed"
cask "zoom"

# Hardware casks
cask "raspberry-pi-imager"    # flash Pi OS to SD/USB
cask "balenaetcher"           # general-purpose image flasher
cask "arduino-ide"
cask "betaflight-configurator" # FPV flight controller config (deprecated upstream:
                               # discontinued, still installs — pin/replace when it breaks)
cask "tailscale-app"          # home/.ssh/config reaches "otto" over a 100.x Tailscale IP
# cask "qgroundcontrol"       # uncomment for MAVLink/ArduPilot ground station
# cask "saleae-logic"         # uncomment if you use a Saleae logic analyzer

###############################################################################
# QuickLook plugins                                                           #
###############################################################################
cask "qlcolorcode"
cask "qlstephen"
cask "qlmarkdown"
# cask "quicklook-json"    # DISABLED upstream 2025-12-23: no longer meets cask criteria
cask "qlprettypatch"
cask "quicklook-csv"
cask "webpquicklook"
cask "suspicious-package"
cask "syntax-highlight"
cask "quicklook-video"    # renamed upstream — the old "qlvideo" cask is gone

###############################################################################
# Mac App Store                                                               #
###############################################################################
mas "Amphetamine", id: 937984704
# mas "BetterSnapTool", id: 417375580
mas "Flycut", id: 442160987
