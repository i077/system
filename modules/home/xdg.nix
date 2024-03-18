# Force all macOS utilities, e.g. zsh, to conform to the XDG Base Directory spec
{
  config,
  lib,
  ...
}: let
  inherit (lib.file) mkOutOfStoreSymlink;
  xdgDir = "${config.home.xdgDirectory}/Library/XDG";
  # Use ~/Library/XDG for storing app files, I don't want any dotfiles cluttering up ~.
  xdg = {
    configHome = "${xdgDir}/config";
    cacheHome = "${xdgDir}/cache";
    dataHome = "${xdgDir}/data";
    runtimeDir = "$TMPDIR";
    stateHome = "${xdgDir}/state";
  };
in {
  xdg = {
    inherit (xdg) configHome cacheHome dataHome stateHome;
  };
  home.sessionVariables.XDG_RUNTIME_DIR = xdg.runtimeDir;
}
