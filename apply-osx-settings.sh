#!/bin/bash

# Close any open System Preferences panes, to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Example macOS settings
# Set the computer name
sudo scutil --set ComputerName "My-Mac"
sudo scutil --set HostName "My-Mac"
sudo scutil --set LocalHostName "My-Mac"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "My-Mac"

# Show all filename extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Add more settings as needed
