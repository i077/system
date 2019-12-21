{ config, pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Display manager
  services.xserver.displayManager.lightdm = {
    enable = true;
  };
  services.xserver.desktopManager.gnome3.enable = true;
  # services.dbus.packages = with pkgs; [ gnome3.dconf ];

  # Caps2esc
  services.interception-tools = {
    enable = true;
    plugins = with pkgs.interception-tools-plugins; [
      caps2esc
    ];
  };

  # Hide cursor (on X) when inactive
  services.xbanish.enable = true;
}
