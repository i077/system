{
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./plex.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "combee";
    networkmanager.enable = true;
  };

  # Enable root login for distributed builds
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTgmWqiXS1b+l8KhvdrjZtbXXCh5UuBnbnase5601p2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG13aSroi6VPpZII3u+0XkJyfE7ldbC6ovvMr3Fl6tMn"
  ];

  # Allow cross-compilation of ARM builds
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
