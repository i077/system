{ config, lib, pkgs, ... }:

{
  home-manager.users.imran.programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [ ms-python.python bbenoist.Nix ];
  };
}
