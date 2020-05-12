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
  };

  # Add rclone to service path
  systemd.services.restic-backups-onedrive = {
    path = with pkgs; [ rclone ];
    environment = with config.private.rcloneConf; {
      RCLONE_CONFIG_ONEDRIVE_TYPE = onedrive.type;
      RCLONE_CONFIG_ONEDRIVE_TOKEN = onedrive.token;
      RCLONE_CONFIG_ONEDRIVE_DRIVE_ID = onedrive.drive_id;
      RCLONE_CONFIG_ONEDRIVE_DRIVE_TYPE = onedrive.drive_type;
    };
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
