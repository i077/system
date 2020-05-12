{ pkgs, ... }:

{
  home-manager.users.imran.programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      extraNativeMessagingHosts = with pkgs; [ passff-host tridactyl-native ];
    };
  };

  home-manager.users.imran.home.sessionVariables = { MOZ_USE_XINPUT2 = 1; };
}
