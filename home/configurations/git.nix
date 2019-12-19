{ config, lib, pkgs, ... }:

lib.mkIf config.programs.git.enable {
  programs.git = {
    userName = "Imran Hossain";
    userEmail = "imran3740@gmail.com";
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
}
