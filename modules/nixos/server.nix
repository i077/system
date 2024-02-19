# Configuration for NixOS servers
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [../nix-distributed.nix];

  # Passwordless accounts, auth is done via keypair
  nix.settings.trusted-users = ["@wheel"];
  security.sudo.wheelNeedsPassword = false;

  # Add user
  users.users.imran = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = inputs.self.lib.mySshKeys;
  };

  environment.systemPackages = with pkgs; [duplicacy htop];

  services.openssh.settings.PermitRootLogin = "no";
  services.tailscale.enable = true;

  # Garbage collect nix stores weekly
  nix.gc = {
    automatic = true;
    dates = "Sunday 04:00";
    options = "--delete-older-than 7d";
  };

  # Workaround for NetworkManager-wait-online timing out
  systemd.services.NetworkManager-wait-online.enable =
    lib.warn "Workaround for issue https://github.com/NixOS/nixpkgs/issues/180175 is still active" (lib.mkForce false);
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
