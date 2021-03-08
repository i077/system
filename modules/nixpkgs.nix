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

        nixpkgs-25420cd = importNixpkgsRev {
          rev = "25420cd7876abeb4eae04912db700de79e51121b";
          sha256 = "140j5fllh8646a9cisnhhm0kmjny9ag9i0a8p783kbvlbgks0n5g";
        };
      in { onedrive = nixpkgs-25420cd.onedrive; })
  ];
}
