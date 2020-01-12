{ config, pkgs, lib, ... }:

let
  sources = import ../../nix/sources.nix;
in
{
  imports = [
    ./backup.nix
    ./hardware-configuration.nix
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

  networking.hostName = "i077-spectrenix";

  # Swapfile
  swapDevices = [
    {device = "/var/swapfile"; size = 4096;}
  ];

  boot = {
    # Use the systemd-boot EFI boot loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Plymouth boot screen
    plymouth.enable = true;

    # Allow trimming on encrypted partition
    initrd.luks.devices."cryptroot" = {
      preLVM = true;
      allowDiscards = true;
    };

    extraModulePackages = [ 
      config.boot.kernelPackages.exfat-nofuse # Support exFAT
    ];

    # Clean up /tmp on boot
    cleanTmpDir = true;
  };

  # Use large console font for HiDPI screen
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # Optimize for SSDs
  fileSystems."/".options = [ "discard" ];

  # OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.optimus_prime = {
    enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
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

  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  # Users
  users.users.imran = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    shell = "/run/current-system/sw/bin/fish";
  };
  home-manager.users.imran = import ../../home/home.nix;
  home-manager.useUserPackages = true;

  # Fish shell
  programs.fish.enable = true;

  # Backlight control
  programs.light.enable = true;

  system.stateVersion = "19.03";
}
