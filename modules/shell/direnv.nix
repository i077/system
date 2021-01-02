{ config, lib, ... }:

let
  cfg = config.modules.shell.direnv;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.direnv.enable = mkEnableOption "Direnv";

  config = mkIf cfg.enable {
    hm.programs.direnv = {
      enable = true;
      enableNixDirenvIntegration = true;

      enableFishIntegration = config.modules.shell.fish.enable;
    };
  };
}
