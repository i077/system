{ config, device, ... }:

{
  home-manager.users.imran.services.onedrive = {
    enable = true;
    monitor = true;
    settings = {
      skip_file = "desktop.ini|Thumbs.db|*.url";
      skip_dir = "backup|Apps|Pictures";
      sync_dir = { spectre = "~/OneDrive"; }.${device.name};
    };
  };

  home-manager.users.imran.home.activation."onedriveDir" = {
    before = [ ];
    after = [ "linkGeneration" ];
    data = ''
      # Ensure sync directory exists
      sync_dir=${config.home-manager.users.imran.services.onedrive.settings.sync_dir}
      [[ -d $sync_dir ]] || mkdir -p $sync_dir
    '';
  };
}
