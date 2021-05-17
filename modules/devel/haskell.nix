{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.devel.haskell;
in {
  options.modules.devel.haskell.enable = mkEnableOption "Haskell development";

  config = mkIf cfg.enable { hm.home = { packages = with pkgs; [ ghc ormolu ]; }; };
}
