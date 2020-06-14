# This module is like home-manager's random-background module, except it works with GNOME and runs
# an arbitrary script to determine which wallpaper to select. This give the user more flexibility in
# which wallpaper to pick based on various conditions such as time of day or choose from various
# sources.

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.gnome-background;
in {
  options = {
    services.gnome-background = {
      enable = mkEnableOption "Background selector for GNOME";

      script = mkOption {
        type = types.path;
        example = "/home/user/Pictures/walls/selector.py";
        description = ''
          Script to run when choosing a new background.
          When run, it must output only a valid path to an image,
          e.g. "/home/user/Pictures/walls/01.jpg". The executable
          bit on this script must be set.
        '';
      };

      display = mkOption {
        type = types.enum [
          "none"
          "wallpaper"
          "centered"
          "scaled"
          "stretched"
          "zoom"
          "spanned"
        ];
        default = "zoom";
        description = "Determines how the background is rendered.";
      };

      interval = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "1h";
        description = ''
          The interval at which a new background will be selected.
          Set this to null to only set a new background upon login.
          Should be formatted as a duration understood by systemd,
          see systemd.time(7) for syntax.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.user.services.gnome-background = {
        Unit = {
          Description = "GNOME Background selector";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = let dconfBin = "${pkgs.dconf}/bin/dconf";
          in toString (pkgs.writeScript "gnome-bg-selector" ''
            #!${pkgs.runtimeShell}
            ${dconfBin} write /org/gnome/desktop/background/picture-options "'${cfg.display}'"
            ${dconfBin} write /org/gnome/desktop/background/picture-uri "'file:///$(${cfg.script})'"
          '');
          IOSchedulingClass = "idle";
        };

        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
    }
    (mkIf (cfg.interval != null) {
      systemd.user.timers.gnome-background = {
        Unit = { Description = "GNOME Background selector"; };

        Timer = { OnUnitActiveSec = cfg.interval; };

        Install = { WantedBy = [ "timers.target" ]; };
      };
    })
  ]);
}
