{ config, lib, ... }:

let
  cfg = config.modules.shell.starship;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.starship.enable = mkEnableOption "Starship prompt";

  config = mkIf cfg.enable {
    hm.programs.starship = {
      enable = true;
      enableFishIntegration = config.modules.shell.fish.enable;
    };
  };
}
