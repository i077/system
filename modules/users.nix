# modules/users.nix -- Define user (and some base home-manager) configuration.

{ config, inputs, lib, ... }:

let inherit (lib.mine.files) mapFilesRecToList;
in {
  users.mutableUsers = false;

  user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" config.users.groups.keys.name ];
    name = "imran";
    description = "Imran Hossain";
  };

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
