{
  description = "My NixOS configurations";

  inputs = {
    # Nixpkgs tracks nixos-unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Manage user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tmux configuration
    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

    # Bobthefish theme for fish
    fish-bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    # Gruvbox colorscheme for fish
    fish-gruvbox = {
      url = "github:Jomik/fish-gruvbox";
      flake = false;
    };

    # Jump to directories by frecency with fish
    fish-z = {
      url = "github:jethrokuan/z";
      flake = false;
    };

    # Workspace scripts for i3
    i3-workspacer = {
      url = "github:cameronleger/i3-workspacer";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      inherit (builtins) attrNames elem filter readDir;
      inherit (nixpkgs.lib) filterAttrs platforms;

      # Get each host in ./hosts (a list of names)
      hostnames = attrNames (filterAttrs (_: type: type == "directory") (readDir ./hosts));

      # Function to check if a host runs on a given platform
      hostIsPlatform = name: platform: elem (import (./hosts + "/${name}")).system platform;

      # List of hosts running NixOS
      nixosHostnames = filter (name: hostIsPlatform name platforms.linux) hostnames;
    in {
      # Map each NixOS host to a NixOS system
      nixosConfigurations = let
        inherit (nixpkgs.lib) genAttrs nixosSystem;

        mkNixosSystem = hostname:
          let device = import (./hosts + "/${hostname}");
          in nixosSystem {
            inherit (device) system;

            modules = [
              nixpkgs.nixosModules.notDetected
              {
                # Set hostname
                networking.hostName = hostname;

                # System revision tracks git commit hash
                system.configurationRevision = self.rev;

                system.stateVersion = "19.03";
              }
              (import (./hosts + "/${hostname}" + /hardware-configuration.nix))

              # Use home-manager
              home-manager.nixosModules.home-manager

              # Import custom packages module
              (import ./packages)

              (import ./modules)
            ];

            # Pass flake inputs and device parameters to modules
            specialArgs = { inherit inputs device; };
          };
      in genAttrs nixosHostnames mkNixosSystem;
    };
}
