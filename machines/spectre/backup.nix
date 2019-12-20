{ config, pkgs, ... }:

{
  services.restic.backups.spectre = {
    repository = "rclone:onedrive:backup";
    paths = [
      "/home/imran"
      "/etc"
    ];
    extraBackupArgs = [
      "-e /home/imran/.cache"
      "--iexclude \".cache\""
      "-e \"Music/\""
      "-x"
      "--exclude-caches"
    ];

    passwordFile = "/etc/nixos/secrets/restic_backup_pass";

    # Run every day
    timerConfig = {
      OnCalendar = "daily";
    };
  };

  # Add rclone to service path
  systemd.services.restic-backups-spectre.path = with pkgs; [
    rclone
  ];
  systemd.services.restic-backups-spectre.environment = {
    RCLONE_CONFIG_ONEDRIVE_TYPE = "onedrive";
    RCLONE_CONFIG_ONEDRIVE_TOKEN = builtins.readFile ../../secrets/rclone_config_onedrive_token;
    RCLONE_CONFIG_ONEDRIVE_DRIVE_ID = "a2694ab35f8cf64";
    RCLONE_CONFIG_ONEDRIVE_DRIVE_TYPE = "personal";
  };
}
