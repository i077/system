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

    # Add other binary caches
    binaryCaches = [ "https://i077.cachix.org" "https://nix-community.cachix.org/" ];
    binaryCachePublicKeys = [
      "i077.cachix.org-1:v28tOFUfUjtVXdPol5FfEO/6wC/VKWnHkD32/aMJJBk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # Grant sudoers rights with the nix daemon
    trustedUsers = [ "root" "@wheel" ];
  };

  nixpkgs.overlays = [
    # Overlay for temporary fixes to broken packages on nixos-unstable
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
      in { })

    # General package patches
    (final: prev: {
      # Patch ranger to run with PyPy instead of CPython.
      # This offers about a 2-3x speedup when working with directories with lots of entries,
      # e.g. the nix store.
      ranger = prev.ranger.overrideAttrs (oa: {
        postFixup = oa.postFixup + ''
          sed -i "s_#!/nix/store/.*_#!${pkgs.pypy3}/bin/pypy3_" $out/bin/.ranger-wrapped
        '';
      });
    })
  ];
}
