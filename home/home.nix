{ config, pkgs, ... }:

let unstableTarball = 
  fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports = [
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

  # User packages
  home.packages = with pkgs; [
    # Command-line utilities
    bat
    fortune
    gopass
    pass
    python3Packages.powerline

    # Apps
    standardnotes

    # Fonts
    iosevka
    inter-ui

    # GNOME Shell extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
    gnomeExtensions.timepp
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
