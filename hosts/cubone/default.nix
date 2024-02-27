{pkgs, ...}: {
  imports = [./hardware-configuration.nix ./argonone.nix];

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    # Raspi 4 kernel
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "cubone";
    interfaces.eth0.useDHCP = true;
    networkmanager = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [dig nmap];

  # Automount attached storage
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/db9b749a-6dd4-4c26-b41b-9efd18a23512";
    fsType = "ext4";
  };

  # Allow additional SSH keys for unattended backup
  users.users.imran.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwxfrYbiYUreL+wKQLUEP8GNhAYNgPnigmt5yveT1n6 NTC-MacBook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvjExjsgc8AhTJva4Lv/bHCxaXjoBvUiQu9ZmFltZU1 dialga"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITRYKr6WJS0tVMXpVF2phNj+UErylLiAe7umC0UjWna Venusaur"
  ];
}
