{ config, lib, options, pkgs, ... }:

let
  cfg = config.modules.hardware.laptop;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine.options) mkEnableOpt';
in {
  options.modules.hardware.laptop = {
    enable = mkEnableOption "laptop-specific features";
    touchpad.enable = mkEnableOpt' "touchpad management";
    orientation.enable = mkEnableOpt' "orientation/light sensors";
    backlight.enable = mkEnableOpt' "backlight control";
    cpugov.enable = mkEnableOpt' "switching CPU governor on AC power";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.touchpad.enable {
      services.xserver.libinput = {
        enable = true;
        tapping = false;
        naturalScrolling = true;
        clickMethod = "clickfinger";
      };
    })

    (mkIf cfg.orientation.enable { hardware.sensor.iio.enable = true; })

    (mkIf cfg.backlight.enable { programs.light.enable = true; })

    (mkIf cfg.cpugov.enable {
      services.udev.extraRules = ''
        ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"
        ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start battery"
        ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start ac"
      '';

      systemd.services.battery = {
        enable = true;
        description = "Runs commands upon switching to battery power";
        script = ''
          ${config.boot.kernelPackages.cpupower}/bin/cpupower frequency-set -g powersave
        '';
      };

      systemd.services.ac = {
        enable = true;
        description = "Runs commands upon switching to AC power";
        script = ''
          ${config.boot.kernelPackages.cpupower}/bin/cpupower frequency-set -g performance
        '';
      };
    })
  ]);
}
