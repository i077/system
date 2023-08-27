{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./plex.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "combee";
    networkmanager.enable = true;
  };

  # Create user for distributed nix builds
  users.groups.nixremote = {};
  users.users.nixremote = {
    isSystemUser = true;
    group = "nixremote";
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = inputs.self.lib.mySshKeys;
  };
  nix.settings.trusted-users = ["nixremote"];

  # Allow cross-compilation of ARM builds
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
