{
  description = "My NixOS configurations";

  inputs = {
    # Nixpkgs tracks nixos-unstable
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    # Manage user environment
    home-manager = {
      url = github:rycee/home-manager;
      flake = false;
    };

    # Build python poetry projects under nix
    poetry2nix.url = github:nix-community/poetry2nix;

    # Tmux configuration
    oh-my-tmux = {
      url = github:gpakosz/.tmux;
      flake = false;
    };

    # Bobthefish theme for fish
    fish-bobthefish = {
      url = github:oh-my-fish/theme-bobthefish;
      flake = false;
    };

    # Gruvbox colorscheme for fish
    fish-gruvbox = {
      url = github:Jomik/fish-gruvbox;
      flake = false;
    };

    # Jump to directories by frecency with fish
    fish-z = {
      url = github:jethrokuan/z;
      flake = false;
    };

    # Workspace scripts for i3
    i3-workspacer = {
      url = github:cameronleger/i3-workspacer;
      flake = false;
    };

    # Neuron zettelkasten
    neuron = {
      url = github:srid/neuron;
      flake = false;
    };
    # neuron.vim
    neuron-vim = {
      url = github:ihsanturk/neuron.vim;
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    # Map each directory in ./hosts to a nixos system
    nixosConfigurations = let
      inherit (builtins) attrNames readDir;
      inherit (nixpkgs.lib) filterAttrs genAttrs removePrefix nixosSystem;

      hosts = let
        hostDirs = attrNames
          (filterAttrs (_: type: type == "directory") (readDir ./hosts));
      in map (name: "i077-" + name) hostDirs;

      mkHostConfig = hostname:
        let
          name = removePrefix "i077-" hostname;
          device = import (./hosts + "/${name}");
        in nixosSystem {
          inherit (device) system;

          modules = [
            nixpkgs.nixosModules.notDetected
            {
              # Set hostname as i077-[host directory name]
              networking.hostName = hostname;

              # System revision tracks git commit hash
              system.configurationRevision = self.rev;

              system.stateVersion = "19.03";
            }
            (import (./hosts + "/${name}" + /hardware-configuration.nix))

            # Use home-manager, which is not yet a flake
            (import (home-manager + "/nixos"))

            # Import custom packages module
            (import ./packages)

            (import ./modules)
          ];

          # Pass flake inputs and device parameters to modules
          specialArgs = { inherit inputs device; };
        };
    in genAttrs hosts mkHostConfig;
  };
}
