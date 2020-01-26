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

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.optimus_prime = {
    enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # Backlight control
  programs.light.enable = true;
}
