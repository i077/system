# Defines the main user that will interact with the machine.

{ config, lib, ... }:

let inherit (lib) mkDefault;
in {
  users.mutableUsers = false;

  user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" config.users.groups.keys.name ];
    name = "imran";
    description = "Imran Hossain";
  };
}
