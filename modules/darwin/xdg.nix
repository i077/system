# Force all macOS utilities, e.g. zsh, to conform to the XDG Base Directory spec
{config, ...}: let
  homeDir = config.home-manager.users.imran.home.homeDirectory;
  xdg = {
    cacheHome = "${homeDir}/Library/Caches";
    configHome = "${homeDir}/Library/Preferences";
    dataHome = "${homeDir}/Library/Application Support";
    runtimeDir = "${homeDir}/Library/Runtime";
    stateHome = "${homeDir}/Library/Saved Application State";
  };
in {
  home-manager.users.imran = {
    xdg = {
      inherit (xdg) cacheHome configHome dataHome stateHome;
    };
  };
}
