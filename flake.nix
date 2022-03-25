{
  description = "My Nix configurations";

  inputs = {
    # Use unstable-small branch for quicker updates
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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

  outputs = { self, nixpkgs, darwin, deploy-rs, devshell, home-manager, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      # Systems supported by this flake
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      mkDarwinConfig = system: path:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [ home-manager.darwinModule ./modules/darwin path ];
          specialArgs = { inherit inputs; };
        };

      mkNixosConfig = system: path:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ path ];
          specialArgs = { inherit inputs; };
        };
    in {
      nixosConfigurations = { cubone = mkNixosConfig "aarch64-linux" ./hosts/cubone; };

      darwinConfigurations = { Venusaur = mkDarwinConfig "aarch64-darwin" ./hosts/venusaur; };

      deploy.nodes = {
        cubone = {
          hostname = "cubone";
          fastConnection = true;
          profiles.system = {
            sshUser = "imran";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cubone;
          };
        };
      };

      checks =
        builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
          inherit (pkgs) lib;

          # Helper function to get x86_64-darwin macOS binary if aarch64-darwin is not available
          rosetta = pkgSet:
            if system == "aarch64-darwin" && !(builtins.hasAttr system pkgSet) then
              pkgSet."x86_64-darwin"
            else
              pkgSet.system;
        in pkgs.devshell.mkShell {
          name = "system";
          packages = with pkgs; [
            # Wrap nix to support flakes
            (writeShellScriptBin "nix" ''
              ${pkgs.nix}/bin/nix --extra-experimental-features "nix-command flakes" "$@"
            '')
            deploy-rs.defaultPackage.${system}
            cachix

            # Formatters used by treefmt
            fish
            luaformatter
            nixfmt
            nodePackages.prettier
          ];

          commands = [{
            help = "Format the entire code tree";
            category = "formatters";
            package = pkgs.treefmt;
          }];
        });
    };
}
