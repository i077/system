{ config, lib, pkgs, ... }:

let
  unstable = import <unstable> {};
in lib.mkIf config.programs.firefox.enable {
  programs.firefox = {
    package = unstable.firefox.override {
      extraNativeMessagingHosts = with pkgs; [ passff-host ];
    };
  };
}
