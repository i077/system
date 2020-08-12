{ config, device, pkgs, ... }:

{
  services.restic.backups.onedrive = {
    repository = "rclone:onedrive:backup";
    paths = [ "/home/imran" "/etc" ];
    extraBackupArgs = [
      "-e /home/imran/.cache"
      ''--iexclude ".cache"''
      ''-e "Music/"''
      "-x"
      "--exclude-caches"
    ];

    passwordFile = config.private.resticPasswordFile;

    # Run every day
    timerConfig = { OnCalendar = "daily"; };

    rcloneConfig = {
      inherit (config.private.rcloneConf.onedrive)
        type token drive_id drive_type;
    };
  };

  # Only run when online
  systemd.services.restic-backups-onedrive = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
