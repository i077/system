{ config, lib, pkgs, ... }:

lib.mkIf config.programs.alacritty.enable {
  programs.fzf = {
    fileWidgetOptions = [ "--preview 'bat --color=always --plain {}'" ];
  };
}
