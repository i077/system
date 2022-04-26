{ pkgs, ... }:

let
  mySSHKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsq7jgT0egpEZ4QpgaFHRRxrwk7vzWVvZE0w7Bhk9hK imran@NTC-MacBook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1YIyqTUGvH71i6MWCsYPVoijYLZWfapmuMSR4aGAh9 Shortcuts on Geodude"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxhrUwCg/DcNQfG8CwIMdJsHu0jZWI2BZV/T6ka5N imran@venusaur"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGGsm2JWPKT+pUJHs7l7el4OJFxQZjkC3T/oxkLUlG9 Shortcuts on venusaur"
  ];

  blocklistPath = "/var/lib/dnsmasq/blocklist";
  blocklistUrl = "https://dnsmasq.oisd.nl/";
in {
  imports = [ ./hardware-configuration.nix ./unbound.nix ./time-machine.nix ];

  system.stateVersion = "20.09";

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

  time.timeZone = "America/New_York";

  # Passwordless accounts, auth is done via keypair
  nix.settings.trusted-users = [ "@wheel" ];
  security.sudo.wheelNeedsPassword = false;

  # Use nix flakes for local flake evaluation
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Add user
  users.users.imran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = mySSHKeys;
  };

  # OpenSSH configuration
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };
  programs.mosh.enable = true;

  services.tailscale.enable = true;

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
