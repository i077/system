{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.services.printing;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.services.printing.enable = mkEnableOption "printing services";

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ brlaser brgenml1cupswrapper brgenml1lpr ];
    };

    # Discover printers on the network
    services.avahi = {
      enable = true;
      nssmdns = true;
    };

    # Scanning
    hardware.sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          home = {
            model = "MFC-9130CW";
            ip = "192.168.86.110";
          };
        };
      };
    };
  };
}
