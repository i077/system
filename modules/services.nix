{ device, lib, pkgs, ... }:

{
  # Geolocation
  services.geoclue2.enable = true;

  # Hide cursor (on X) when inactive
  # services.xbanish.enable = true;

  services.logind.extraConfig = ''
    # Suspend on power key pressed
    HandlePowerKey=suspend
  '';

  # Caps2esc for non-flashable keyboards
  services.interception-tools = lib.optionalAttrs (!device.kbFlashable) {
    enable = true;
    plugins = with pkgs.interception-tools-plugins; [
      caps2esc
    ];
  };
}
