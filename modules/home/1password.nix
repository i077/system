{ config, lib, pkgs, ... }:
let
  home = config.home.homeDirectory;
  darwinSockPath = "${home}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  sockPath = "${home}/.1password/agent.sock";
in {
  home.sessionVariables.SSH_AUTH_SOCK = sockPath;
  home.file.".1password/agent.sock".source =
    lib.mkIf pkgs.stdenvNoCC.isDarwin (config.lib.file.mkOutOfStoreSymlink darwinSockPath);
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent "${sockPath}"
    '';
  };
}
