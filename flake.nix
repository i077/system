{
  description = "My NixOS configurations";

  inputs = {
    # Nixpkgs tracks nixos-unstable
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    # Manage user environment
    home-manager = {
      type = "github";
      owner = "rycee";
      repo = "home-manager";
      flake = false;
    };

    # Build python poetry projects under nix
    poetry2nix = {
      type = "github";
      owner = "nix-community";
      repo = "poetry2nix";
    };

    # Tmux configuration
    oh-my-tmux = {
      type = "github";
      owner = "gpakosz";
      repo = ".tmux";
      flake = false;
    };

    # Bobthefish theme for fish
    fish-bobthefish = {
      type = "github";
      owner = "oh-my-fish";
      repo = "theme-bobthefish";
      flake = false;
    };

    # Jump to directories by frecency with fish
    fish-z = {
      type = "github";
      owner = "jethrokuan";
      repo = "z";
      flake = false;
    };

    # Workspace scripts for i3
    i3-workspacer = {
      type = "github";
      owner = "cameronleger";
      repo = "i3-workspacer";
      flake = false;
    };

    # Neuron zettelkasten
    neuron = {
      type = "github";
      owner = "srid";
      repo = "neuron";
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
          system = "x86_64-linux";

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
