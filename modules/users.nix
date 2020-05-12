{ config, device, pkgs, ... }:

{
  users = {
    mutableUsers = false;

    users.imran = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "networkmanager"
        "adbusers"
        "wireshark"
        "audio"
        "pulse" 
      ];
      hashedPassword = config.private.hashedLogins.${device.name}.imran;
      uid = 1000;
      description = "Imran Hossain";
      shell = pkgs.fish;
    };

    users.root.hashedPassword = config.private.hashedLogins.${device.name}.root;
  };

  # Allow authentication through U2F
  security.pam.u2f = {
    enable = true;
    cue = true;
    control = "sufficient";
    authFile = config.private.u2fAuthFile;
  };
  security.pam.services = builtins.listToAttrs (map (name: {
    inherit name;
    value = { u2fAuth = true; };
  }) [
    "login"
    "polkit-1"
    "su"
    "sudo"
    "systemd-user"
    "xlock"
  ]);

  # Define home-manager environment
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
