{ config, lib, ... }:

lib.mkIf config.programs.broot.enable {
  programs.broot = {
    enableFishIntegration = true;
  };
}
