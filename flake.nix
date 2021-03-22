{
  description = "My NixOS configurations";

  inputs = {
    # Nixpkgs tracks nixos-unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # A nicer `nix develop` experience
    devshell.url = "github:numtide/devshell";

    # Manage user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";

    # Nix language server
    rnix-lsp.url = "github:nix-community/rnix-lsp";

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Tmux configuration
    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
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

  nixConfig = {
    substituters =
      [ "https://i077.cachix.org" "https://cache.nixos.org" "https://nix-community.cachix.org/" ];
    trusted-public-keys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs@{ self, nixpkgs, devshell, home-manager, sops-nix, ... }:
    let
      inherit (lib) mkDefault mkIf nixosSystem removeSuffix;
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
              system.configurationRevision = mkIf (self ? rev) self.rev;
              networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
              nixpkgs.overlays = [ self.overlay inputs.neovim-nightly-overlay.overlay ];
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

      # Shell with dependencies for managing other outputs
      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
          nixBin = pkgs.writeShellScriptBin "nix" ''
            ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
          '';
        in pkgs.devshell.mkShell {
          name = "system-shell";

          env = let nv = lib.nameValuePair;
          in [
            # Export PGP keys for sops
            (nv "sopsPGPKeyDirs"
              ''"$DEVSHELL_ROOT/secrets/pubkeys/hosts" "$DEVSHELL_ROOT/secrets/pubkeys/users"'')
            {
              name = "PATH";
              prefix = "bin";
            }
          ];

          packages = with pkgs; [
            sops-nix.packages.${system}.sops-pgp-hook
            fish
            git
            git-crypt
            gnupg
            nixBin
            restic
            utillinux
          ];

          commands = [
            # Packages
            { package = pkgs.sops; }
            { package = pkgs.nixfmt; }
            {
              package = pkgs.gitAndTools.gh;
            }

            # Custom commands
            {
              name = "update-pr";
              help = "View the latest flakebot PR";
              category = "maintenance";
              command = "${pkgs.gitAndTools.gh}/bin/gh pr view -c flakebot";
            }
            {
              name = "secrets";
              help = "Edit secrets.yaml with sops";
              category = "maintenance";
              command = "${pkgs.sops}/bin/sops secrets/secrets.yaml";
            }
          ];
        });
    };
}
