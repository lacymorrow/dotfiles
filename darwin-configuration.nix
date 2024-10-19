{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    nodejs
    yarn
    firefox
    vlc
    iterm2
    docker
    coreutils
    ffmpeg
    nvm
    yarn
    pnpm
    eslint
    npm-check-updates
    imagemagick
    wget
    zsh
    bat
    glib
    mas
    rpm
    snapcraft
    trash
    wine
    zlib
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    # Add more packages as needed
  ];

  services = {
    # Add services here
  };

  system = {
    stateVersion = "22.11"; # Update this to the current version
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.telemetry = false;

  homebrew.enable = true;
  homebrew.casks = [
    "visual-studio-code"
    "font-fira-code"
    "dash"
    "angry-ip-scanner"
    "flycut"
    "cyberduck"
    "google-chrome"
    "gimp"
    "inkscape"
    "ngrok"
    "postman"
    "slack"
    "spectacle"
    "spotify"
    "transmission"
    "ultimaker-cura"
    "unetbootin"
    "vagrant"
    "virtualbox"
    "vmware-fusion"
    "xquartz"
    "warp"
    "zoom"
    # Add more casks as needed
  ];

  mas.enable = true;
  mas.apps = [
    { name = "Amphetamine"; id = 937984704; }
    { name = "BetterSnapTool"; id = 417375580; }
    # Add more apps as needed
  ];

  # Custom activation script to apply macOS settings
  system.activationScripts.applyOSXSettings = {
    text = ''
      #!/bin/bash
      ${pkgs.bash}/bin/bash ./apply-macos-settings.sh
    '';
  };
}
