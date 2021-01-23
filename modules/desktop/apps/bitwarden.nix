{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.modules.desktop.apps.bitwarden;
in {
  options.modules.desktop.apps.bitwarden = {
    enable = mkEnableOption "Bitwarden password manager";
    cli.enable = mkEnableOption "Bitwarden CLI";
  };

  config = mkIf cfg.enable (mkMerge [
    { hm.home.packages = with pkgs; [ bitwarden ]; }
    (mkIf cfg.cli.enable { hm.home.packages = with pkgs; [ bitwarden-cli rbw ]; })
  ]);
}
