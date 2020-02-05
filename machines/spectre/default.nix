{ config, pkgs, lib, ... }:

let
  sources = import ../../nix/sources.nix;
in {
  imports = [
    ../common

    ./autorandr.nix
    ./backup.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  boot = {
    # Allow trimming on encrypted partition
    initrd.luks.devices."cryptroot" = {
      preLVM = true;
      allowDiscards = true;
    };
  };

  hardware.opengl = {
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  networking.hostName = "i077-spectrenix";

  # Swapfile
  swapDevices = [
    {device = "/var/swapfile"; size = 4096;}
  ];

  # Use large console font for HiDPI screen
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # Optimize for SSDs
  fileSystems."/".options = [ "discard" ];

  services.xserver = {
    videoDrivers = [ "intel" ];

    # Prevent screen tearing on Intel Graphics
    deviceSection = ''
      Option      "TearFree"    "true"
    '';
  };

  # NVIDIA
  hardware.bumblebee.enable = true;

  # Backlight control
  programs.light.enable = true;
}
