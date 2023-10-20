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

    nixvim.url = "github:nix-community/nixvim";

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
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux"];

      imports = [
        ./flake/devshell.nix
        ./flake/hosts.nix
        ./flake/rescue.nix
        ./flake/pkgs.nix
      ];
    };
}
