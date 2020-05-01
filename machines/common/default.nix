{ config, pkgs, lib, ... }:

let sources = import ../../nix/sources.nix;
in {
  imports = [
    ./keybase.nix
    ./packages.nix
    ./printing.nix
    ./services.nix
    ./yubikey.nix

    # Home manager
    "${sources.home-manager}/nixos"
  ];

  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Use latest linux kernel (default is LTS)
    kernelPackages = pkgs.linuxPackages_latest;

    # Plymouth boot screen
    plymouth.enable = true;

    extraModulePackages = with config.boot.kernelPackages; [];

    # Clean up /tmp on boot
    cleanTmpDir = true;
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Audio + bluetooth
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth = {
    enable = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Networking
  networking.networkmanager.enable = true;

  # Set timezone
  time.timeZone = "America/New_York";

  # Include manpage and devel outputs for packages
  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  # Users
  users.users.imran = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "adbusers" ];
    shell = "/run/current-system/sw/bin/fish";
  };
  home-manager.users.imran = import ../../home/home.nix;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # Fish shell
  programs.fish.enable = true;

  programs.adb.enable = true;
  services.udev.packages = with pkgs; [ android-udev-rules ];

  system.stateVersion = "19.03";
}
