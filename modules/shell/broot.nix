{ config, lib, ... }:

let
  cfg = config.modules.shell.broot;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.broot.enable = mkEnableOption "broot";

  config = mkIf cfg.enable {
    hm.programs.broot = {
      enable = true;
      enableFishIntegration = config.modules.shell.fish.enable;
    };
  };
}
