{ ... }:

{
  home-manager.users.imran.programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    fileWidgetOptions = [ "--preview 'bat --color=always --plain {}'" ];
  };
}
