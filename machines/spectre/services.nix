{ config, pkgs, ... }:

{
  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;

    tapping = false;
    naturalScrolling = true;
    clickMethod = "clickfinger";
  };

  # Caps2esc
  services.interception-tools = {
    enable = true;
    plugins = with pkgs.interception-tools-plugins; [
      caps2esc
    ];
  };
}
