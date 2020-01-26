{ config, pkgs, ... }:

{
  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser
      brgenml1cupswrapper
      brgenml1lpr
    ];
  };
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
        home = { model = "MFC-9130CW"; ip = "192.168.86.110"; };
      };
    };
  };
}
