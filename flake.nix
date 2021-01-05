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

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";

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

  outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, ... }:
    let
      inherit (lib) mkDefault nixosSystem removeSuffix;
      inherit (lib.mine.files) mapFiles mapFilesRec mapFilesRecToList;

      # List of systems supported by this flake
      supportedSystems = [ "x86_64-linux" ];

      # Function to generate set based on supported systems,
      # e.g. { x86_64-linux = f "x86_64-linux"; }
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Memoize nixpkgs for each supported system
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Extend nixpkgs.lib with my own helper functions
      lib = nixpkgs.lib.extend (final: prev: { mine = import ./lib final; });

      # Generate a NixOS configuration given a path to a host's config
      mkNixosHost = path:
        nixosSystem {
          system = import (path + "/system.nix");
          specialArgs = { inherit inputs lib; };
          modules = [
            {
              networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
              nixpkgs.overlays = [ self.overlay ];
            }
            (import path)
          ] ++ mapFilesRecToList import ./modules;
        };

      # Generate a set of derivations for all packages defined in ./packages
      mkMyPkgs = pkgs: mapFiles (p: pkgs.callPackage p { }) ./packages;
    in {
      lib = lib.mine;

      nixosConfigurations = mapFiles mkNixosHost ./hosts;

      nixosModules = mapFilesRec import ./modules;

      homeManagerModules = mapFiles import ./hm-modules;

      packages = forAllSystems (system:
        # Evaluate packages with an unfree-enabled nixpkgs
        mkMyPkgs (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }));

      overlay = final: prev: mkMyPkgs final;

      # Shell with dependencies for do script
      devShell = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in pkgs.mkShell {
          # Export PGP keys for sops
          sopsPGPKeyDirs = [ "./secrets/pubkeys/hosts" "./secrets/pubkeys/users" ];
          nativeBuildInputs = [ sops-nix.packages.${system}.sops-pgp-hook ];

          buildInputs = with pkgs; [ fish git git-crypt gnupg nixFlakes nixfmt sops utillinux ];
        });
    };
}
