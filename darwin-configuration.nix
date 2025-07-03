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
    nvm
    pnpm
    eslint
    npm-check-updates
    zsh
    glib
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    curl
    # Packages moved to Brewfile: ffmpeg, imagemagick, wget, bat, mas, rpm, snapcraft, trash, wine, zlib
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
    "font-fira-code"
    "dash"
    "flycut"
    "ultimaker-cura"
    "vmware-fusion"
    "warp"
    # Casks moved to Brewfile for consistency: visual-studio-code, angry-ip-scanner, cyberduck, google-chrome, gimp, inkscape, ngrok, postman, slack, spotify, transmission, unetbootin, vagrant, virtualbox, xquartz, zoom
    # Add more casks as needed
  ];

  mas.enable = true;
  mas.apps = [
    # Mac App Store apps moved to Brewfile for consistency
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
