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

  environment.gnome3.excludePackages = with pkgs.gnome3; [
    gnome-software # No need for this since we use declarative nix
  ];

  home-manager.users.imran.home.packages = with pkgs; [ gnome3.gnome-tweaks ];
}
