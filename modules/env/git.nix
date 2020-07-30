{ config, pkgs, ... }:

{
  home-manager.users.imran.programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

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

    # Use delta for diffs
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      syntax-theme = "gruvbox";
      features = "decorations";
      decorations = {
        file-style = "bold white ul";
        file-decoration-style = "none";
        whitespace-error-style = "22 reverse";
      };
    };

    extraConfig = { 
      core.editor = config.defaultApplications.editor.desktop;

      sendemail = with config.private.email; {
        smtpserver = smtpServ;
        smtpserverport = smtpPort;
        smtpuser = username;
        smtpencryption = smtpEncryption;
        smtppass = password;
      };

      pull.rebase = false;
    };
  };

  # Add extensions to git
  home-manager.users.imran.home.packages = with pkgs; [ git-crypt ];
}
