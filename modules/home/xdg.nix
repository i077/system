# Force all macOS utilities, e.g. zsh, to conform to the XDG Base Directory spec
{
  config,
  ...
}: let
  # Use ~/Library/XDG for storing app files, I don't want any dotfiles cluttering up ~.
  xdgSubdir = "Library/XDG";
  xdgDir = "${config.home.homeDirectory}/Library/XDG";
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

  home.file."${xdgSubdir}/.keep".text = "";
}
