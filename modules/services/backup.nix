{ config, options, lib, pkgs, ... }:
let
  cfg = config.modules.services.backup;
  inherit (lib) mkEnableOption mkOption mkIf types;
in {
  options.modules.services.backup = {
    enable = mkEnableOption "Restic backup service";

    paths = mkOption {
      description = "Paths to backup. Defaults to user's home directory.";
      type = types.listOf types.str;
      example = [ "/home/user" "/etc" ];
      default = [ "/home/${config.user.name}" ];
    };

    excludes = mkOption {
      description = "File patterns to exclude.";
      type = types.listOf types.str;
      example = [ ".cache" "foo/**/bar" ];
      apply = pkgs.writeText "backup-excludes.txt";
    };

    calendar = mkOption {
      description = "How often to run backups.";
      type = types.str;
      default = "daily";
    };
  };

  config = mkIf cfg.enable {
    # TODO switch to onsite backups
    services.restic.backups.onedrive = {
      repository = "rclone:onedrive:backup";
      inherit (cfg) paths;
      extraBackupArgs = [
        "--exclude-caches"
        "--exclude-file=${cfg.excludes}"
      ]
      # Exclude OneDrive sync directory
        ++ (lib.optional config.modules.services.onedrive.enable
          "-e ${config.modules.services.onedrive.sync_dir}");

      rcloneConfig = {
        inherit (config.private.rcloneConf.onedrive) type token drive_id drive_type;
      };

      passwordFile = config.private.resticPasswordFile;

      timerConfig = { OnCalendar = cfg.calendar; };
    };

    # Only run when online
    systemd.services.restic-backups-onedrive = { after = [ "NetworkManager-wait-online.target" ]; };
  };
}
