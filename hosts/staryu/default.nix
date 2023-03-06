{inputs, ...}: {
  imports = [./hardware-configuration.nix inputs.nixos-hardware.nixosModules.microsoft-surface-common];

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "staryu";
    networkmanager.enable = true;
  };

  # Lock, but don't suspend, on lid close
  # This is meant to run server workloads
  services.logind.lidSwitch = "lock";

  # Enable distributed builds
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTgmWqiXS1b+l8KhvdrjZtbXXCh5UuBnbnase5601p2"];
}
