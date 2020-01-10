{ config, lib, ... }:

lib.mkIf config.services.onedrive.enable {
  services.onedrive.monitor = true;
  services.onedrive.settings = {
    skip_file = "desktop.ini|Thumbs.db|*.url";
    skip_dir = "backup|Apps|Pictures";
  };
}
