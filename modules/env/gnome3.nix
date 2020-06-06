{ pkgs, ... }:

{
  # Enable GNOME 3
  services.xserver.desktopManager.gnome3.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # GNOME tools
  environment.systemPackages = (with pkgs.gnome3; [ dconf-editor ]) ++
    # Extensions
    (with pkgs.gnomeExtensions; [
      appindicator
      dash-to-dock
      gsconnect
      night-theme-switcher
      paperwm
    ]);

  home-manager.users.imran.home.packages = with pkgs; [ gnome3.gnome-tweaks ];
}
