{ config, lib, ... }:

let
  cfg = config.modules.services.onedrive;
  inherit (lib) concatStringsSep mkEnableOption mkIf mkOption types;

  # For specifying patterns to skip in syncing
  multiPattern = concatStringsSep "|";
in {
  options.modules.services.onedrive = {
    enable = mkEnableOption "OneDrive syncing";
    sync_dir = mkOption {
      description = "Directory to sync OneDrive with.";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    hm.services.onedrive = {
      enable = true;
      monitor = true;
      settings = {
        skip_file = multiPattern [ "desktop.ini" "Thumbs.db" "*.url" ];
        skip_dir = multiPattern [ "backup" "Apps" "Pictures" "Documents/Rainmeter" ];
        inherit (cfg) sync_dir;
      };
    };

    # Ensure sync directory exists
    hm.home.activation."onedriveDir" = {
      before = [ ];
      after = [ "linkGeneration" ];
      data = ''
        sync_dir=${config.home-manager.users.imran.services.onedrive.settings.sync_dir}
        [[ -d $sync_dir ]] || mkdir -p $sync_dir
      '';
    };
  };
}
