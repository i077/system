{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./time-machine.nix ];

  boot = {
    loader.grub.enable = false;
    # Raspi-specific boot settings
    loader.raspberryPi = {
      enable = true;
      version = 4;
    };

    # Raspi 4 kernel
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

  # Add 2GB swap
  swapDevices = [{
    device = "/var/swapfile";
    size = 2048;
  }];

  # Networking -- I only use Ethernet, no wireless here
  networking.hostName = "cubone";
  networking.interfaces.eth0.useDHCP = true;

  environment.systemPackages = with pkgs; [ dig nmap ];
}
