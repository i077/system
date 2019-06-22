{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # User packages
  home.packages = [
    pkgs.fortune
    pkgs.iosevka
    pkgs.bat
  ];

  # Git
  programs.git = {
    enable = true;
    userName = "Imran Hossain";
    userEmail = "imran3740@gmail.com";
    extraConfig = {
      core.editor = "nvim";
    };
  };

  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "none";
      background_opacity = 0.8;
      font.normal.family = "Iosevka";
      font.bold.family = "Iosevka";
      font.italic.family = "Iosevka";
    };
  };

  # Fonts
  fonts.fontconfig.enable = true;
}
