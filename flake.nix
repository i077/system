{
  description = "My Nix configurations";

  inputs = {
    # Use unstable-small branch for quicker updates
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # A nicer developer env experience
    devshell.url = "github:numtide/devshell";

    # Easily deploy changes to systems
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  nixConfig = {
    substituters = [
      "https://i077.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org/"
    ];
    trusted-public-keys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = { self, nixpkgs, deploy-rs, devshell, ... }@inputs:
    let
      # Systems supported by this flake
      systems =
        [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      nixosConfigurations = {
        cubone = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./hosts/cubone ];
          specialArgs = { inherit inputs; };
        };
      };

      deploy.nodes = {
        cubone = {
          hostname = "cubone";
          fastConnection = true;
          profiles.system = {
            sshUser = "imran";
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.cubone;
          };
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
        in pkgs.devshell.mkShell {
          name = "system";
          packages = with pkgs; [
            # Wrap nix to support flakes
            (writeShellScriptBin "nix" ''
              ${pkgs.nix}/bin/nix --option experimental-features "nix-command flakes" "$@"
            '')
            nixfmt
            deploy-rs.defaultPackage.${system}
            cachix
          ];
        });
    };
}
