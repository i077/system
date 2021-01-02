{ ... }:

{
  # Geolocation
  services.geoclue2.enable = true;

  # Hide cursor (on X) when inactive
  # services.xbanish.enable = true;

  services.logind.extraConfig = ''
    # Suspend on power key pressed
    HandlePowerKey=suspend
  '';
}
