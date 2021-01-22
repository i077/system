{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.bat;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.bat.enable = mkEnableOption "bat";

  config = mkIf cfg.enable {
    hm.programs.bat = {
      enable = true;
      config = { pager = "less -FR"; };
    };
  };
}
