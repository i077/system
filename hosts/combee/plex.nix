{...}: {
  # Mount data drive
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/62f089d4-627b-4812-8e58-f7ae47fc9f2b";
    fsType = "ext4";
    options = [
      "noauto" # Don't mount automatically at boot
      "x-systemd.automount"
    ];
  };

  # Expose drive as SMB share
  services.samba = {
    enable = true;
    openFirewall = true;
    shares.plexdata = {
      path = "/mnt/data/plex";
      comment = "combee Plex media";
      "valid users" = ["imran"];
      "read only" = false;
    };
  };

  # Plex Media Server
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Allow Plex to access video devices, e.g. a TV tuner
  users.users.plex.extraGroups = ["video"];
}
