{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.hardware.bluetooth;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.hardware.bluetooth = { enable = mkEnableOption "Bluetooth support"; };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings = { General.Enable = "Source,Sink,Media,Socket"; };
    };

    # PulseAudio support
    hardware.pulseaudio = {
      package = pkgs.pulseaudioFull;
      # Add module
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };
}
