{ config, lib, ... }:

let
  cfg = config.modules.shell.fzf;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.fzf.enable = mkEnableOption "command-line fuzzy finder";

  config = mkIf cfg.enable {
    hm.programs.fzf = {
      enable = true;
      enableFishIntegration = config.modules.shell.fish.enable;

      fileWidgetOptions = [
        # Preview the contents of the selected file
        "--preview 'bat --color=always --plain {}'"
      ];

      changeDirWidgetOptions = [
        # Preview the contents of the selected directory
        "--preview 'exa -l --tree --level=2 --color=always {}'"
      ];
    };
  };
}
