# Default config for my servers
{
  pkgs,
  lib,
  ...
}: let
  mySSHKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsq7jgT0egpEZ4QpgaFHRRxrwk7vzWVvZE0w7Bhk9hK imran@NTC-MacBook"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1YIyqTUGvH71i6MWCsYPVoijYLZWfapmuMSR4aGAh9 Shortcuts on Geodude"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQRxhrUwCg/DcNQfG8CwIMdJsHu0jZWI2BZV/T6ka5N imran@venusaur"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGGsm2JWPKT+pUJHs7l7el4OJFxQZjkC3T/oxkLUlG9 Shortcuts on venusaur"
  ];
in {
  imports = [../broken-overlay.nix ../nix-settings.nix];

  system.stateVersion = "20.09";

  time.timeZone = "America/New_York";

  # Passwordless accounts, auth is done via keypair
  nix.settings.trusted-users = ["@wheel"];
  security.sudo.wheelNeedsPassword = false;

  # Add user
  users.users.imran = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = mySSHKeys;
  };

  # OpenSSH configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  programs.mosh.enable = true;

  services.tailscale.enable = true;

  # Garbage collect nix stores weekly
  nix.gc = {
    automatic = true;
    dates = "Sunday 04:00";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [duplicacy];

  # Workaround for NetworkManager-wait-online timing out
  systemd.services.NetworkManager-wait-online.enable =
    lib.warn "Workaround for issue https://github.com/NixOS/nixpkgs/issues/180175 is still active" (lib.mkForce false);
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
