{ config, device, inputs, lib, pkgs, ... }:

{
  # Link each input to /etc/sources
  environment.etc = (lib.mapAttrs'
    (name: value: (lib.nameValuePair "sources/${name}" { source = value; }))
    inputs);

  nix = {
    nixPath = lib.mkForce [
      "nixpkgs=/etc/sources/nixpkgs"
      "home-manager=/etc/sources/home-manager"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    # Auto-optimize nix store
    optimise.automatic = true;

    # Grant suderos rights with the nix daemon
    trustedUsers = [ "root" "@wheel" ];

    # Use flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      flake = inputs.nixpkgs;
    };

    binaryCaches = [ "https://cache.nixos.org" ];
    binaryCachePublicKeys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    ];
  };

  nixpkgs.config = import ../nixpkgs-config.nix;

  # Include devel outputs for packages
  documentation.dev.enable = true;

  # Overlay for temporary fixes to broken packages on nixos-unstable
  nixpkgs.overlays = [
    (self: super:
      let
        # Import nixpkgs at a specified commit
        importNixpkgsRev = { rev, sha256 }:
          import (builtins.fetchTarball {
            name = "nixpkgs-src-" + rev;
            url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
            inherit sha256;
          }) {
            inherit (device) system;
            inherit (config.nixpkgs) config;
            overlays = [ ];
          };

        nixpkgs-b3c3a0b = importNixpkgsRev {
          rev = "b3c3a0bd1835a3907bf23f5f7bd7c9d18ef163ec";
          sha256 = "0b9n5arqr3pzyg1ws0wf84zlczgllxnhjm1mzddd1qk5w5nw7fcy";
        };
      in {
        inherit (nixpkgs-b3c3a0b) quodlibet-full;
      })
  ];
}
