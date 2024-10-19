{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    tmux
    # Add user-specific packages here
  ];

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  home.file.".aliases" = {
    source = ./home/.aliases
  };

  home.file.".docker_aliases" = {
    source = ./home/.docker_aliases
  };
  
  home.file.".bash_profile" = {
    source = ./home/.bash_profile
  };

  home.file.".bash_prompt" = {
    source = ./home/.bash_prompt
  };

  home.file.".bashrc" = {
    source = ./home/.bashrc
  };

  home.file.".editorconfig" = {
    text = builtins.readFile ./home/.editorconfig;
  };

  home.file.".exports" = {
    source = ./home/.exports
  };

  home.file.".functions" = {
    source = ./home/.functions
  };

  home.file.".gitconfig" = {
    text = builtins.readFile ./home/.gitconfig;
  };

  home.file.".gvimrc" = {
    text = builtins.readFile ./home/.gvimrc;
  };

  home.file.".hgrc" = {
    text = builtins.readFile ./home/.hgrc;
  };

  home.file.".hushlogin" = {
    text = builtins.readFile ./home/.hushlogin;
  };

  home.file.".inputrc" = {
    text = builtins.readFile ./home/.inputrc;
  };

  home.file.".npmrc" = {
    text = builtins.readFile ./home/.npmrc;
  };

  home.file.".zprofile" = {
    source = ./home/.zprofile;
  };

  # Set up NVM environment
  home.sessionVariables = {
    NVM_DIR = "$HOME/.nvm";
  };

  # Enable Yarn Corepack
  home.activation = {
    enableYarnCorepack = ''
      corepack enable || echo "Could not enable Yarn Corepack"
    '';
  };
}
