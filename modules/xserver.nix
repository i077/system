{ pkgs, lib, device, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";

    # Use Intel HD Graphics for optimus devices
    videoDrivers = {
      optimus = [ "intel" ];
      nvidia = [ "nvidia" ];
    }.${device.gpu};

    # Prevent screen tearing on Intel Graphics
    deviceSection = lib.optionalString (device.gpu == "optimus") ''
      Option      "TearFree"    "true"
    '';

    # Touchpad
    libinput = {
      enable = device.isLaptop;
      tapping = false;
      naturalScrolling = true;
      clickMethod = "clickfinger";
    };

    # Display manager
    displayManager.lightdm = { enable = true; };

    # Window manager
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
