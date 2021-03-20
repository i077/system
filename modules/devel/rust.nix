{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.devel.rust;
in {
  options.modules.devel.rust.enable = mkEnableOption "Rust development";

  config = mkIf cfg.enable {
    hm.home = {
      packages = with pkgs; [ rustup ];
      sessionVariables = {
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
      };
    };
  };
}
