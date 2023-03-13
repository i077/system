# Force all macOS utilities, e.g. zsh, to conform to the XDG Base Directory spec
{config, ...}: let
  inherit (config.home-manager.users.imran.lib.file) mkOutOfStoreSymlink;
  homeDir = config.home-manager.users.imran.home.homeDirectory;
  # Use ~/Library for storing app files, I don't want any dotfiles cluttering up ~.
  # The exception is .config, where user-declared preferences are set (and the macOS analog,
  # ~/Library/Preferences, according to the Apple Developer docs, shouldn't have directories
  # created by random apps.
  xdg = {
    cacheHome = "${homeDir}/Library/Caches";
    dataHome = "${homeDir}/Library/Application Support";
    runtimeDir = "$TMPDIR";
    stateHome = "${homeDir}/Library/Saved Application State";
  };
in {
  home-manager.users.imran = {
    xdg = {
      inherit (xdg) cacheHome dataHome stateHome;
    };
    home.sessionVariables.XDG_RUNTIME_DIR = xdg.runtimeDir;
  };
}
