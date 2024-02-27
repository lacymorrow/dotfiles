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

# Disable telemetry
brew analytics off

# brew cask
brew tap buo/cask-upgrade

# Install all brew apps (including CLI 'trash' and 'wget' commands)
	# "node" \ # We use NVM
	# "mercurial" \
	# "awscli" \
	# "python" \
	# "python3" \
	# "tig" \
	# "zsh" \
	# "cmake" \
	# Core application library for C - https://formulae.brew.sh/formula/glib
	# "glib" \
	# These add symlinks for GNU utilities - https://apple.stackexchange.com/a/69332
	# "coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep" \

for app in "node" \
	"coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep" \
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
# fira code
echo "installing fira code"
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# *********************************
# a better `cat`
brew install bat

	# "hyper" \
	# "iterm2" \
	# "sublime-text" \
	# "vagrant" \
	# "vmware-fusion" \
for app in "dash" \
	"amphetamine" \
	"angry-ip-scanner" \
	"docker" \
	"flycut" \
	"cyberduck" \
	"firefox" \
	"google-chrome" \
	"gimp" \
	"inkscape" \
	"iterm2" \
	"ngrok" \
	"postman" \
	"slack" \
	"spectacle" \
	"spotify" \
	"synergy-core" \
	"transmission" \
	"ultimaker-cura" \
	"unetbootin" \
	"unrarx" \
	"vlc" \
	"virtualbox" \
	"xquartz" \
    "zoom"; do
	brew install --cask "${app}"
done

# Amphetamine
mas install 937984704

# Installs handy quick-look plugins https://github.com/sindresorhus/quick-look-plugins

	# "qlcolorcode" \ # or syntax-highlight
	# "quicklookase" \ # Adobe Color swatch exchanf
for app in "apparency" \
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
