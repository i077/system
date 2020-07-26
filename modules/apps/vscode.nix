{ config, lib, pkgs, ... }:

{
  home-manager.users.imran.programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [ ms-python.python bbenoist.Nix ];

    userSettings = {
      # Updates are handled through nix
      "update.channel" = "none";
      "extensions.autoUpdate" = false;

      # Font
      "editor.fontLigatures" = true;
      "editor.fontFamily" = builtins.concatStringsSep ", " [
        "'${config.theming.fonts.mono.family}'"
        "'monospace'"
        "'Droid Sans Fallback'"
      ];

      # UI
      "editor.lineNumbers" = "off";
      "editor.minimap.enabled" = false;

      # Python
      "python.pythonPath" = "/etc/profiles/per-user/imran/bin/python3";
      "python.formatting.provider" = "black";
      "python.formatting.blackPath" = "${pkgs.python3Packages.black}/bin/black";
      "python.defaultInterpreterPath" = "python3"; # Should pick up from nix-shell
      "python.autoUpdateLanguageServer" = false;
      "python.languageServer" = "Microsoft";
    };
  };
}
