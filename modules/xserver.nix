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

    # ...and on NVIDIA graphics
    screenSection = lib.optionalString (device.gpu == "nvidia") ''
      Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
    '';

    # Touchpad
    libinput = {
      enable = device.isLaptop;
      tapping = false;
      naturalScrolling = true;
      clickMethod = "clickfinger";
    };

    # Display manager
    displayManager.gdm = { enable = true; };
  };
}
