{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./unbound.nix ./time-machine.nix ];

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

  # Pihole
  # Open ports 53 to accept DNS requests, 80 for pihole portal, 67 for DHCP
  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 67 ];
  virtualisation.oci-containers.containers.pihole = {
    autoStart = true;
    image = "pihole/pihole:2022.04.3";
    ports = [ "53:53/tcp" "53:53/udp" "80:80" ];
    volumes = [ "/var/lib/pihole/:/etc/pihole/" "/var/lib/dnsmasq.d:/etc/dnsmasq.d/" ];
    environment = {
      TZ = "America/NewYork";
      DNSSEC = "true";
    };
    extraOptions = [ "--cap-add=NET_ADMIN" "--net=host" ];
    workdir = "/var/lib/pihole/";
  };

  environment.systemPackages = with pkgs; [ dig nmap ];
}
