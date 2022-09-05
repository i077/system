{
  description = "My Nix configurations";

  inputs = {
    # Use unstable-small branch for quicker updates
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # NixOS modules for running on certain hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Manage macOS systems with Nix
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Manage user environment with Nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "github:numtide/flake-utils";

    # A nicer developer env experience
    devshell.url = "github:numtide/devshell";

    # Easily deploy changes to systems
    deploy-rs.url = "github:serokell/deploy-rs";

    # Jump to directories by frecency with fish
    fish-z = {
      url = "github:jethrokuan/z";
      flake = false;
    };

    # Async fish prompt
    fish-tide = {
      url = "github:IlanCosman/tide";
      flake = false;
    };

    # Utilities for the Argon One Raspi case
    argonone-utils = {
      url = "github:mgdm/argonone-utils";
      flake = false;
    };
  };

  nixConfig = {
    substituters =
      [ "https://i077.cachix.org" "https://cache.nixos.org" "https://nix-community.cachix.org/" ];
    trusted-public-keys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, darwin, deploy-rs, devshell, home-manager, utils, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      mkDarwinConfig = system: path:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [ home-manager.darwinModule ./modules/darwin path ];
          specialArgs = { inherit inputs; };
        };

      mkNixosConfig = system: path:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./modules/nixos path ];
          specialArgs = { inherit inputs; };
        };
    in {
      nixosConfigurations = { cubone = mkNixosConfig "aarch64-linux" ./hosts/cubone; };

      darwinConfigurations = {
        NTC-MacBook = mkDarwinConfig "x86_64-darwin" ./hosts/ntc-macbook;
        Venusaur = mkDarwinConfig "aarch64-darwin" ./hosts/venusaur;
      };

      deploy = {
        fastConnection = true;
        sshUser = "imran";
        user = "root";
        nodes = {
          cubone = {
            hostname = "cubone";
            profiles.system.path =
              deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cubone;
          };
        };
      };

      checks =
        builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShells = utils.lib.eachDefaultSystemMap (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
          inherit (pkgs) lib;
        in {
          default = pkgs.devshell.mkShell {
            name = "system";
            packages = with pkgs; [
              # Wrap nix to support flakes
              (writeShellScriptBin "nix" ''
                ${pkgs.nix}/bin/nix --extra-experimental-features "nix-command flakes" "$@"
              '')
              cachix
              jo

              # Formatters used by treefmt
              fish
              luaformatter
              nixfmt
              nodePackages.prettier
            ];

            commands = [
              {
                help = "Format the entire code tree";
                package = pkgs.treefmt;
              }
              {
                name = "deploy";
                help = "Deploy profiles to servers";
                package = deploy-rs.defaultPackage.${system};
              }
            ];
          };
        });
    };
}
