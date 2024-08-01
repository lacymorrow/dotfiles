#!/usr/bin/env sh

echo ""
echo "#############################"
echo "# Installing applications via Homebrew from brew.sh"
echo "#############################"
echo ""

###############################################################################
# HomeBrew                                                                    #
###############################################################################

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)" 
eval "$(/usr/local/bin/brew shellenv)" 

# Disable telemetry
brew analytics off

# brew cask
brew tap buo/cask-upgrade

# Install all brew apps (including CLI 'trash' and 'wget' commands)
	# "mercurial" \
	# "awscli" \
	# "python" \
	# "python3" \
	# "tig" \
	# "zsh" \
	# "cmake" \
	# Core application library for C - https://formulae.brew.sh/formula/glib
	# "glib" \
	# "zsh-completions" \

	# "node" \

for app in "bat" \
	"ffmpeg" \
	"glib" \
	"imagemagick" \
	"mas" \
	"rpm" \
	"snapcraft" \
	"trash" \
	"wget" \
	"wine" \
	"zlib" \
	"zsh-autosuggestions" \
	"zsh-completions" \
	"zsh-syntax-highlighting"; do
	brew install "${app}"
done


# *********************************
# Visual studio code
brew install --cask visual-studio-code

# get current location
# DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# if [ -L ~/Library/Application\ Support/Code/user/settings.json ]; then
#   echo "found old visual studio code settings. removing..."
#   rm ~/Library/Application\ Support/Code/User/settings.json
# fi

# Link VSCode settings
# ln -s $DIR/visual-studio-code-settings.json ~/Library/Application\ Support/Code/User/settings.json

# *********************************
# fira code font
# echo "installing fira code"
# brew tap homebrew/cask-fonts
# brew install --cask font-fira-code

# *********************************

	# These add symlinks for GNU utilities - https://apple.stackexchange.com/a/69332
	# "coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep" \
	# "caffeine" \
	# "dash" \
	# "iterm2" \
	# "vmware-fusion" \
	# "ultimaker-cura" \
	# "flycut" \

for app in "coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep" \
	"angry-ip-scanner" \
	"docker" \
	"cyberduck" \
	"firefox" \
	"google-chrome" \
	"gimp" \
	"inkscape" \
	"ngrok" \
	"postman" \
	"slack" \
	"spectacle" \
	"spotify" \
	"transmission" \
	"unetbootin" \
	"vagrant"\
	"vlc" \
	"virtualbox" \
	"xquartz" \
	"warp" \
 	"zoom"; do
	brew install --cask "${app}"
done


# Install Mac Apps
mas install 937984704 # Amphetamine
mas install 417375580 # BetterSnapTool
mas install 442160987 # Flycut
# mas install 408981434 # iMovie

# Installs handy quick-look plugins https://github.com/sindresorhus/quick-look-plugins

	# "qlcolorcode" \ # or syntax-highlight
	# "quicklookase" \ # Adobe Color swatch exchanf
for app in "qlcolorcode" \
	"qlstephen" \
	"qlmarkdown" \
	"quicklook-json" \
	"qlprettypatch" \
	"quicklook-csv" \
	"betterzipql" \
	"qlimagesize" \
	"webpquicklook" \
	"suspicious-package" \
	"syntax-highlight" \
	"qlvideo"; do
	brew install --cask "${app}"
done
