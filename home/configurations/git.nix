{ config, lib, pkgs, ... }:

let
in
lib.mkIf config.programs.git.enable {
  programs.git = {
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

    extraConfig = {
      core.editor = "nvim";
    };
  };

  # Add extra packages that extend git
  home.packages = with pkgs; [
    git-crypt
  ];
}
