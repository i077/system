{ pkgs, ... }: {
  programs.home-manager.enable = true;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      HOMEBREW_NO_AUTO_UPDATE = 1;
    };
    packages = with pkgs; [
      exa bat
    ];
  };
}
