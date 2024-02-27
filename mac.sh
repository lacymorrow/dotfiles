#!/usr/bin/env sh

echo ""
echo "#############################"
echo "# Setting global mac configs from mac.sh"
echo "#############################"
echo ""

# Enable tap-to-click
# https://apple.stackexchange.com/questions/382098/how-to-enable-tap-to-click-using-keyboard-only
echo "Enable tap-to-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Enable 3 finger gestures
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerSwipeGesture -int 1

# Enable Dictation
# https://sudoai.dev/
echo "Enable dictation"
defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMMasterSwitchOff -bool false

echo "show hidden files by default"
defaults write com.apple.Finder AppleShowAllFiles -bool true

echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Show Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

# echo "Stop iTunes from responding to the keyboard media keys"
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null