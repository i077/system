{ lib, pkgs, ... }:

let
  extensions = with pkgs.vscode-extensions; [ ms-python.python bbenoist.Nix ];

  vscode-with-extensions =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in { home-manager.users.imran.home.packages = [ vscode-with-extensions ]; }
