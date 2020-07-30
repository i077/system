{ pkgs, ... }:

{
  home-manager.users.imran.programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "gruvbox";
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
}
