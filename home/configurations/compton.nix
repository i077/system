{ config, lib, pkgs, ... }:

lib.mkIf config.services.compton.enable {
  services.compton = {
    fade = true;
    fadeDelta = 5;
    shadow = true;
  };
}
