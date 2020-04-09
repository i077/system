{ config, pkgs, lib, ...}:

let
  sources = import ../../nix/sources.nix {};
in {

  # Derive channels from sources.nix
  environment.etc."sources/nixpkgs".source = sources.nixpkgs;
  environment.etc."sources/home-manager".source = sources.home-manager;

  nix = {
    nixPath = lib.mkForce [
      "nixpkgs=/etc/sources/nixpkgs"
      "home-manager=/etc/sources/home-manager"
      "nixos-config=/etc/nixos/configuration.nix"
      "nixpkgs-overlays=/etc/nixos/overlays"
    ];

    # Optimize nix store automatically
    autoOptimiseStore = true;

    # Grant sudoers rights with the nix daemon
    trustedUsers = [ "root" "@wheel" ];
  };
  
  nixpkgs.pkgs = import sources.nixpkgs {
    config = import ../../nixpkgs-config.nix;
  };

  nixpkgs.overlays = with builtins;
    map (name: import (../../overlays + "/${name}")) (attrNames (readDir ../../overlays));

  # System packages
  environment.systemPackages = with pkgs; [
    acpi
    binutils
    file
    freetype
    gdb
    gitFull
    htop
    keybase-gui
    libsecret
    neovim
    niv
    nix-index
    openconnect
    patchelf
    pciutils
    pkg-config
    psmisc
    my-python3Full
    powertop
    rclone
    ripgrep
    unzip
    wget

    manpages
    stdmanpages
  ];

}
