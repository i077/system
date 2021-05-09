{ config, options, lib, pkgs, ... }:
let
  cfg = config.modules.services.backup;
  inherit (lib) concatStringsSep mkEnableOption mkOption mkIf types;
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
      apply = l: pkgs.writeText "backup-excludes.txt" (concatStringsSep "\n" l);
    };

    calendar = mkOption {
      description = "How often to run backups.";
      type = types.str;
      default = "daily";
    };
  };

  config = mkIf cfg.enable {
    # Declare secrets
    sops.secrets.restic-pass = { };

    services.restic.backups.minidepot = {
      repository = "rest:https://minidepot.imranh.xyz:6053/";
      passwordFile = config.sops.secrets.restic-pass.path;

      inherit (cfg) paths;
      extraBackupArgs = [
        "--exclude-caches"
        "--exclude-file=${cfg.excludes}"
      ]
      # Exclude OneDrive sync directory
        ++ (lib.optional config.modules.services.onedrive.enable
          "-e ${config.modules.services.onedrive.sync_dir}");

      timerConfig = { OnCalendar = cfg.calendar; };
    };

    # Only run when online
    systemd.services.restic-backups-minidepot = {
      serviceConfig = {
        SupplementaryGroups = config.users.groups.keys.name;
        Restart = "on-failure";
        RestartSec = 15;
      };
      after = [ "NetworkManager-wait-online.target" ];
    };

    # Add restic to environment
    environment.systemPackages = [ pkgs.restic ];
  };
}
