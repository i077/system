{ config, lib, options, ... }:

let
  cfg = config.modules.desktop.gaming.steam;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.gaming.steam = { enable = mkEnableOption "Steam gaming app"; };

  config = mkIf cfg.enable { programs.steam.enable = true; };
}
