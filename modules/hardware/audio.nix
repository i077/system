{ config, lib, options, ... }:

let
  cfg = config.modules.hardware.audio;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.hardware.audio = { enable = mkEnableOption "audio support"; };

  config = mkIf cfg.enable {
    # Enable ALSA
    sound.enable = true;

    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    user.extraGroups = [ "audio" "pulse" ];
  };
}
