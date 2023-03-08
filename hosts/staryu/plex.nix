{...}: {
  # Mount data drive
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/62f089d4-627b-4812-8e58-f7ae47fc9f2b";
    fsType = "ext4";
  };

  # Expose drive as SMB share
  services.samba = {
    enable = true;
    openFirewall = true;
    shares.plexdata = {
      path = "/mnt/data/plex";
      comment = "staryu Plex media";
      "valid users" = ["imran"];
      "read only" = false;
    };
  };

  # Plex Media Server
  services.plex = {
    enable = true;
    openFirewall = true;
  };
}
