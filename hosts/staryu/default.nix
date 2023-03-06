{
  inputs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix inputs.nixos-hardware.nixosModules.microsoft-surface-common];

  boot.loader.systemd-boot.enable = true;

  # This will be on AC usually, so set CPU governor to ondemand
  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "staryu";
    networkmanager.enable = true;
  };

  # Lock, but don't suspend, on lid close
  # This is meant to run server workloads
  services.logind.lidSwitch = "lock";

  # Enable root login for distributed builds
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTgmWqiXS1b+l8KhvdrjZtbXXCh5UuBnbnase5601p2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG13aSroi6VPpZII3u+0XkJyfE7ldbC6ovvMr3Fl6tMn"
  ];

  # Allow cross-compilation of ARM builds
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  nixpkgs.config.allowUnfree = true;

  # Plex Media Server
  services.plex = {
    enable = true;
    openFirewall = true;
  };
}
