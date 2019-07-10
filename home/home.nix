{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
  custompkgs = import ./packages {};
in
{
  imports = [
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./tmux.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # User packages
  home.packages = with unstable; [
    # Command-line utilities
    bat
    fortune
    fzf
    gopass
    pass
    python3Packages.powerline
    tmuxPlugins.resurrect

    # Apps
    android-studio
    standardnotes

    # Languages
    dart

    # Fonts
    iosevka
    inter-ui

    # GNOME Shell extensions
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.mediaplayer
    gnomeExtensions.timepp
  ] ++ 
  # Custom packages from above (defined in ./packages/)
  [
    custompkgs.paperwm 
    custompkgs.budspencer
  ];

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
