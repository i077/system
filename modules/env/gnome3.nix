{ pkgs, ... }:

{
  # Enable GNOME 3
  services.xserver.desktopManager.gnome3.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Extensions
  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    gsconnect
    night-theme-switcher
    paperwm
  ];
}
