# modules/devel/java.nix -- Java (sigh) related development tools

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.java;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.devel.java.enable = mkEnableOption "Java development tools";

  config = mkIf cfg.enable { hm.home.packages = with pkgs; [ openjdk jetbrains.idea-ultimate ]; };
}
