{ config, pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;

    tapping = false;
    naturalScrolling = true;
    clickMethod = "clickfinger";
  };

  # Display manager
  services.xserver.displayManager.lightdm = {
    enable = true;
  };

  # Caps2esc
  services.interception-tools = {
    enable = true;
    plugins = with pkgs.interception-tools-plugins; [
      caps2esc
    ];
  };

  # Geolocation
  services.geoclue2.enable = true;

  # Hide cursor (on X) when inactive
  services.xbanish.enable = true;
}
