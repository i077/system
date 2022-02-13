{ pkgs, ... }:

let
  mySSHKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsq7jgT0egpEZ4QpgaFHRRxrwk7vzWVvZE0w7Bhk9hK imran@NTC-MacBook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1YIyqTUGvH71i6MWCsYPVoijYLZWfapmuMSR4aGAh9 Shortcuts on Geodude"
  ];

  blocklistPath = "/var/lib/dnsmasq/blocklist";
  blocklistUrl = "https://dnsmasq.oisd.nl/";
in {
  imports = [ ./hardware-configuration.nix ];

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

  services.tailscale.enable = true;

  # Pihole-like functionality with dnsmasq
  services.dnsmasq = {
    enable = true;

    # Use CloudFlare's DNS servers
    servers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    alwaysKeepRunning = true;

    # Block ads & trackers with dnsmasq
    extraConfig = ''
      conf-file=${blocklistPath}
    '';
  };
  # Open port 53 to accept DNS requests
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  # Ensure at least an empty blocklist exists before starting dnsmasq,
  # otherwise it might fail to start
  systemd.services.dnsmasq.preStart = ''
    mkdir -p $(dirname ${blocklistPath})
    touch ${blocklistPath}
  '';

  # Update the blocklist from notracking's repo every night
  systemd.services.dnsmasq-update-blocklist = {
    startAt = "*-*-* 03:00:00";
    script = ''
      ${pkgs.curl}/bin/curl -sSL -o ${blocklistPath} ${blocklistUrl}
      systemctl restart dnsmasq.service
    '';
  };
}
