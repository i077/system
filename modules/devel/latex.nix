# modules/devel/latex.nix -- LaTeX stuff

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.latex;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.devel.latex.enable = mkEnableOption "LaTeX tools";

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      (texlive.combine { inherit (texlive) scheme-small latexmk; })
      texlab
    ];
  };
}
