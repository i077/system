{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.desktop.utils.autorandr;
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf mkMerge mkOption types;
in {
  options.modules.desktop.utils.autorandr = {
    enable = mkEnableOption "Autorandr";
    profiles = mkOption { type = types.attrs; };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [{
        assertion = cfg.profiles != null;
        message = "At least one profile must be defined for autorandr.";
      }];

      hm.programs.autorandr.enable = true;

      hm.programs.autorandr.profiles =
        mkAliasDefinitions options.modules.desktop.utils.autorandr.profiles;

      # Add some other XRandR-related stuff
      hm.home.packages = with pkgs; [ arandr ];
    }

    (mkIf config.modules.desktop.i3.enable {
      # Run on i3 start
      hm.xsession.windowManager.i3.config.startup = [{
        command = "${pkgs.autorandr}/bin/autorandr -c --force --default common";
        always = true;
      }];

      # Tell i3 to restart every time autorandr is run
      hm.programs.autorandr.hooks.postswitch."notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
    })
  ]);
}
