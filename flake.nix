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

    # Easily deploy changes to systems
    deploy-rs.url = "github:serokell/deploy-rs";

    # Dev-environment stuff
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";

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

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.devshell.flakeModule
        # Workaround to allow merging of flake's deploy option
        {options.flake.deploy = inputs.nixpkgs.lib.mkOption {};}
      ];
      systems = ["x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux"];

      flake = let
        inherit (inputs) self nixpkgs deploy-rs darwin home-manager;
        inherit (nixpkgs.lib) mkMerge;

        mkDarwinConfig = system: path:
          darwin.lib.darwinSystem {
            inherit system;
            modules = [home-manager.darwinModule ./modules/darwin path];
            specialArgs = {inherit inputs;};
          };

        mkNixosDeployment = name: system: {
          nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [./modules/nixos ./hosts/${name}];
            specialArgs = {inherit inputs;};
          };
          deploy.nodes.${name} = {
            hostname = name;
            profiles.system.path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
          };
        };
      in
        mkMerge [
          (mkNixosDeployment "cubone" "aarch64-linux")
          (mkNixosDeployment "staryu" "x86_64-linux")
          {
            darwinConfigurations = {
              NTC-MacBook = mkDarwinConfig "x86_64-darwin" ./hosts/ntc-macbook;
              Venusaur = mkDarwinConfig "aarch64-darwin" ./hosts/venusaur;
            };

            deploy = {
              sshUser = "imran";
              user = "root";
            };

            checks =
              builtins.mapAttrs
              (system: deployLib: deployLib.deployChecks self.deploy)
              deploy-rs.lib;
          }
        ];

      perSystem = {
        config,
        inputs',
        pkgs,
        ...
      }: {
        devshells.default = {
          name = "system";
          packages = with pkgs; [
            # Wrap nix to support flakes
            (writeShellScriptBin "nix" ''
              ${lib.getExe nix} --extra-experimental-features "nix-command flakes" "$@"
            '')
            cachix
            jo
          ];

          commands = [
            {package = pkgs.just;}
            {package = config.treefmt.build.wrapper;}
            {
              name = "deploy";
              help = "Deploy profiles to servers";
              package = inputs'.deploy-rs.packages.default;
            }
          ];
        };

        treefmt = {
          projectRootFile = ".git/config";
          programs.alejandra.enable = true;
          programs.prettier.enable = true;
          settings.formatter.fish = {
            command = "${pkgs.fish}/bin/fish_indent";
            options = ["--write"];
            includes =
              ["*.fish"]
              ++
              # Format scripts in ./bin interpreted by fish
              builtins.filter
              (f: builtins.substring 0 19 (builtins.readFile ./bin/${f}) == "#!/usr/bin/env fish")
              (builtins.attrNames (builtins.readDir ./bin));
          };
          settings.formatter.lua = {
            command = pkgs.lib.getExe pkgs.luaformatter;
            options = ["-i" "--column-limit=100" "--indent-width=2"];
            includes = ["*.lua"];
          };
          settings.formatter.just = {
            command = pkgs.lib.getExe pkgs.just;
            options = ["--fmt" "--unstable" "-f"];
            includes = ["Justfile"];
          };
        };
      };
    };
}
