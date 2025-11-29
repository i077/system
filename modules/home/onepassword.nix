{config, ...}: let
  home = config.home.homeDirectory;
  darwinSockPath = "${home}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in {
  home.sessionVariables.SSH_AUTH_SOCK = darwinSockPath;
  programs.ssh = {
    extraConfig = ''
      IdentityAgent "${darwinSockPath}"
    '';
  };
}
