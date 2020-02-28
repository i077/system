{ config, lib, ... }:
lib.mkIf config.programs.direnv.enable {
  # Enable fish integration
  programs.direnv.enableFishIntegration = true;
}
