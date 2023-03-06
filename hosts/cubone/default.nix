{pkgs, ...}: {
  imports = [./hardware-configuration.nix ./argonone.nix ./time-machine.nix];

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
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 2048;
    }
  ];

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "cubone";
    interfaces.eth0.useDHCP = true;
    networkmanager = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [dig nmap];

  # Enable IP forwarding for use as Tailscale exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Automount attached storage
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/db9b749a-6dd4-4c26-b41b-9efd18a23512";
    fsType = "ext4";
  };
}
