{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Imran Hossain";
    userEmail = "imran3740@gmail.com";
    extraConfig = {
      core.editor = "nvim";
    };
  };
}
