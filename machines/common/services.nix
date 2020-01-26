{ ... }:

{
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Display manager
  services.xserver.displayManager.lightdm = {
    enable = true;
  };

  # Geolocation
  services.geoclue2.enable = true;

  # Hide cursor (on X) when inactive
  services.xbanish.enable = true;
}

