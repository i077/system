{ config, lib, pkgs, ... }:

lib.mkIf config.services.picom.enable {
  services.picom = {
    fade = true;
    fadeDelta = 5;
    shadow = true;
  };
}
