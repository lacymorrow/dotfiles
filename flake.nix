{
  description = "Lacy's Nix-Darwin configuration for macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {
    darwinConfigurations = {
      mac = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./darwin-configuration.nix
          ./home.nix
        ];
      };
    };
  };
}
