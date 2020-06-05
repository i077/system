{ pkgs, ... }:

{
  home-manager.users.imran.services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    pinentryFlavor = "gnome3";
  };

  services.dbus.packages = [ pkgs.gcr ];
}
