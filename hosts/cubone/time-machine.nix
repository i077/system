# This module adds a backup drive and exposes it via SMB as a Time Machine compatible backup drive.
{ ... }: {
  # Mount backup drive
  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/62f089d4-627b-4812-8e58-f7ae47fc9f2b";
    fsType = "ext4";
    options = [ "noexec" "noatime" "nodiratime" ];
  };

  # Expose time machine directory via SMB
  services.samba = {
    enable = true;
    openFirewall = true;
    shares.timemachine = {
      path = "/mnt/backup/time_machine";
      comment = "Time Machine";
      "valid users" = [ "imran" ];
      "read only" = false;
      "vfs objects" = "catia fruit streams_xattr";
      "fruit:time machine" = true;
    };
  };
}
