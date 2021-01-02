# modules/devel/nix.nix -- Nix-related development tools

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.nix;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.devel.nix.enable = mkEnableOption "Nix development tools";

  config =
    mkIf cfg.enable { hm.home.packages = with pkgs; [ nix-index manix niv nixfmt nix-diff ]; };
}
