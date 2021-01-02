{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.bat;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.bat.enable = mkEnableOption "bat";

  config = mkIf cfg.enable {
    hm.programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = config.modules.theming.batTheme;
      };

      # Provide gruvbox theme from upstream
      themes = {
        gruvbox = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "peaceant";
          repo = "gruvbox";
          rev = "e3db74d0e5de7bc09cab76377723ccf6bcc64e8c";
          hash = "sha256-gsk3qdx+OHMvaOVOlbTapqp8iakA350yWT9Jf08uGoU=";
        } + "/gruvbox.tmTheme");
      };
    };
  };
}
