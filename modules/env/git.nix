{ config, pkgs, ... }:

{
  home-manager.users.imran.programs.git = {
    enable = true;

    userName = "Imran Hossain";
    userEmail = "contact@imranhossa.in";
    signing.key = "211F871962EA405B";

    aliases = {
      ci = "commit -v";
      co = "checkout";
      cob = "checkout -b";
      f = "fetch";
      l = "log";
      lg = "log --oneline --graph --decorate";
      lga = "log --oneline --graph --decorate --all";
      pd = "pull";
      pu = "push";
      pushall = "!git remote | xargs -L1 git push --all";
      st = "status";
    };

    extraConfig = { core.editor = config.defaultApplications.editor.desktop; };
  };

  # Add extensions to git
  home-manager.users.imran.home.packages = with pkgs; [ git-crypt ];
}
