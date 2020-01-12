{ config, lib, pkgs, ... }:

let
in lib.mkIf config.programs.firefox.enable {
  programs.firefox = {
    package = pkgs.firefox.override {
      extraNativeMessagingHosts = with pkgs; [ passff-host ];
    };
  };
}
