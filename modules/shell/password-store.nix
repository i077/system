{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.password-store;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.password-store.enable = mkEnableOption "password-store";

  config = mkIf cfg.enable {
    hm.programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions
        (exts: with exts; [ pass-audit pass-checkup pass-genphrase pass-update ]);
      settings = { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
    };
  };
}
