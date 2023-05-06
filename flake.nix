{
  description = "My Nix configurations";

  inputs = {
    # Use unstable-small branch for quicker updates
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # NixOS modules for running on certain hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Manage macOS systems with Nix
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Manage user environment with Nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";

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
    substituters = ["https://i077.cachix.org" "https://cache.nixos.org" "https://nix-community.cachix.org/"];
    trusted-public-keys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    deploy-rs,
    devshell,
    home-manager,
    utils,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    mkDarwinConfig = system: path:
      darwin.lib.darwinSystem {
        inherit system;
        modules = [home-manager.darwinModule ./modules/darwin path];
        specialArgs = {inherit inputs;};
      };

    mkNixosConfig = system: path:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./modules/nixos path];
        specialArgs = {inherit inputs;};
      };
  in {
    nixosConfigurations = {
      cubone = mkNixosConfig "aarch64-linux" ./hosts/cubone;
      staryu = mkNixosConfig "x86_64-linux" ./hosts/staryu;
    };

    darwinConfigurations = {
      NTC-MacBook = mkDarwinConfig "x86_64-darwin" ./hosts/ntc-macbook;
      Venusaur = mkDarwinConfig "aarch64-darwin" ./hosts/venusaur;
    };

    deploy = {
      sshUser = "imran";
      user = "root";
      nodes = {
        cubone = {
          hostname = "cubone";
          profiles.system.path =
            deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cubone;
        };
        staryu = {
          hostname = "staryu";
          profiles.system.path =
            deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.staryu;
        };
      };
    };

    checks =
      builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    lib = {
      # Helper function to generate variables for `just repl`
      mkReplVars = {hostname}: let
        pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
      in {
        inherit pkgs;
        inherit (pkgs) lib;
        flake = self;
        inherit
          (self
            .${
              if pkgs.stdenv.isDarwin
              then "darwinConfigurations"
              else "nixosConfigurations"
            }
            .${hostname})
          config
          ;
      };
    };

    devShells = utils.lib.eachDefaultSystemMap (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [devshell.overlays.default];
      };
      inherit (pkgs) lib;
    in {
      default = pkgs.devshell.mkShell {
        name = "system";
        packages = with pkgs; [
          # Wrap nix to support flakes
          (writeShellScriptBin "nix" ''
            ${lib.getExe pkgs.nix} --extra-experimental-features "nix-command flakes" "$@"
          '')
          cachix
          jo
        ];

        commands = [
          {package = pkgs.just;}
          {
            help = "Format the entire code tree";
            package = inputs.treefmt-nix.lib.mkWrapper pkgs {
              projectRootFile = ".git/config";
              programs.alejandra.enable = true;
              programs.prettier.enable = true;
              settings.formatter.fish = {
                command = "${pkgs.fish}/bin/fish_indent";
                options = ["--write"];
                includes =
                  map (x: "bin/${x}") [
                    ","
                    "git-peek"
                    "mount-backup"
                    "nixfetch"
                    "pywith"
                    "show"
                    "sysdo"
                  ]
                  ++ ["*.fish"];
              };
              settings.formatter.lua = {
                command = lib.getExe pkgs.luaformatter;
                options = ["-i" "--column-limit=100" "--indent-width=2"];
                includes = ["*.lua"];
              };
              settings.formatter.just = {
                command = lib.getExe pkgs.just;
                options = ["--fmt" "--unstable" "-f"];
                includes = ["Justfile"];
              };
            };
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
