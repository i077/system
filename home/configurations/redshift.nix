{ config, lib, pkgs, ... }:

lib.mkIf config.services.redshift.enable {
  services.redshift = {
    # Detect location automatically
    provider = "geoclue2";

    tray = true;
  };
}
