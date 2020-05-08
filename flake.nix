{
  description = "My NixOS configurations";

  edition = 201909;

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

    # Manage dependencies for nix projects
    niv = {
      type = "github";
      owner = "nmattia";
      repo = "niv";
      flake = false;
    };

    # Build python poetry projects under nix
    poetry2nix = {
      type = "github";
      owner = "nix-community";
      repo = "poetry2nix";
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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    # Map each directory in ./hosts to a nixos system
    nixosConfigurations = let
      inherit (builtins) attrNames filter readDir;
      inherit (nixpkgs.lib) genAttrs removePrefix nixosSystem;

      hosts = map (name: "i077-" + name)
        (filter (n: n != "common") ((attrNames (readDir ./machines))));

      mkHostConfig = hostname:
        let
          name = removePrefix "i077-" hostname;
        in nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              # System config revision tracks commit hash of this flake
              system.configurationRevision = self.rev;
            }

            (import (./machines + "/${name}"))
          ];
          # Pass flake inputs to modules
          specialArgs = { inherit inputs; };
        };
    in genAttrs hosts mkHostConfig;
  };
}
