{ config, inputs, lib, pkgs, ... }:

{
  # Link each input to /etc/sources
  environment.etc =
    (lib.mapAttrs' (name: value: (lib.nameValuePair "sources/${name}" { source = value; })) inputs);

  nix = {
    # Set nix path
    nixPath =
      lib.mkForce [ "nixpkgs=/etc/sources/nixpkgs" "home-manager=/etc/sources/home-manager" ];

    # Auto-optimize nix store
    optimise.automatic = true;

    # Use flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # System-wide registry
    registry.nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      flake = inputs.nixpkgs;
    };

    # Add personal cachix cache
    binaryCaches = [ "https://i077.cachix.org" "https://nix-community.cachix.org/" ];
    binaryCachePublicKeys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Allow unfree evaluation
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # Overlay for temporary fixes to broken packages on nixos-unstable
  nixpkgs.overlays = [
    (final: prev:
      let
        # Import nixpkgs at a specified commit
        importNixpkgsRev = { rev, sha256 }:
          import (builtins.fetchTarball {
            name = "nixpkgs-src-" + rev;
            url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
            inherit sha256;
          }) {
            inherit (config.nixpkgs) config system;
            overlays = [ ];
          };

        nixpkgs-f5e8bdd = importNixpkgsRev {
          rev = "f5e8bdd07d1afaabf6b37afc5497b1e498b8046f";
          sha256 = "1fmwkb2wjfrpx8fis4x457vslam0x8vqlpfwqii6p9vm33dyxhzk";
        };
      in { nix-diff = nixpkgs-f5e8bdd.nix-diff; })
  ];
}
