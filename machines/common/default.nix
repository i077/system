{ config, pkgs, lib, ... }:

{
  imports = [
    ./keybase.nix
    ./packages.nix
    ./printing.nix
    ./services.nix
    ./yubikey.nix

    # Home manager
    <home-manager/nixos>

    # Used for Brother scanners
    <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
  ];

  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Plymouth boot screen
    plymouth.enable = true;

    extraModulePackages = [ 
      config.boot.kernelPackages.exfat-nofuse # Support exFAT
    ];

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

  # Fish shell
  programs.fish.enable = true;

  programs.adb.enable = true;
  services.udev.packages = with pkgs; [ android-udev-rules ];

  system.stateVersion = "19.03";
}
