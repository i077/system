{ config, lib, ... }:

let
  cfg = config.modules.services.onedrive;
  inherit (lib) mkEnableOption mkIf mkOption types;
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
        skip_file = "desktop.ini|Thumbs.db|*.url";
        skip_dir = "backup|Apps|Pictures";
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
