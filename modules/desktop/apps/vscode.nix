{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.vscode;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.apps.vscode.enable = mkEnableOption "Visual Studio Code";

  config = mkIf cfg.enable {
    hm.programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [ ms-python.python bbenoist.Nix ];
    };
  };
}
