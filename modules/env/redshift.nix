{ ... }:

{
  home-manager.users.imran.services.redshift = {
    enable = true;

    provider = "geoclue2";

    # Leave icon in tray
    tray = true;

    temperature = {
      day = 6500;
      night = 3700;
    };
  };
}
