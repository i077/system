{ config, lib, pkgs, ... }:

lib.mkIf config.programs.alacritty.enable {
  programs.alacritty.settings = {
    window.decorations = "none";
    background_opacity = 0.8;
    font.normal.family = "Iosevka";
    font.bold.family = "Iosevka";
    font.italic.family = "Iosevka";
  };
}
