{ config, lib, pkgs, ... }:

lib.mkIf config.programs.password-store.enable {
  programs.password-store = {
    package = pkgs.pass.withExtensions (exts: with exts; [
      pass-audit
      pass-checkup
      pass-genphrase
      pass-update
    ]);
    settings = {
      PASSWORD_STORE_DIR = "/home/imran/.password-store";
    };
  };

  # Add gopass
  home.packages = [ pkgs.gopass ];
}
