# modules/users.nix -- Define user (and some base home-manager) configuration.

{ config, inputs, lib, ... }:

let inherit (lib.mine.files) mapFilesRecToList;
in {
  users.mutableUsers = false;

  user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    name = "imran";
    description = "Imran Hossain";
    hashedPassword = config.private.hashedLogins.${config.networking.hostName}.imran;
  };

  users.users.root.hashedPassword = config.private.hashedLogins.${config.networking.hostName}.root;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  hm.programs.home-manager.enable = true;

  # Import custom home-manager modules
  hm.imports = mapFilesRecToList import ../hm-modules;

  # Autostart user systemd services
  hm.systemd.user.startServices = true;

  # Grant sudoers rights with the nix daemon
  nix.trustedUsers = [ "root" "@wheel" ];
}
