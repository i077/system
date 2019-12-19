{ config, lib, pkgs, ... }:

lib.mkIf config.programs.password-store.enable {
  programs.password-store = {
    settings = {
      PASSWORD_STORE_DIR = "/home/imran/.password-store";
    };
  };
}
