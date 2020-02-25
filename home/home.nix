{ config, pkgs, ... }:

{
  imports = with builtins;
    map (name: ./modules + "/${name}") (attrNames (readDir ./modules)) ++
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations));

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
  };

  nixpkgs.config = import ../nixpkgs-config.nix;
  nixpkgs.overlays = import ../overlays;

  # User packages
  home.packages = with pkgs; [
    # Command-line utilities
    ctags
    exa
    gnumake
    hugo
    ix
    maim
    openfortivpn
    pandoc
    passff-host
    pinentry-gtk2
    ranger
    tomb
    neovim-remote
    xsel

    # Apps
    android-studio
    brscan4
    lazygit
    libreoffice-fresh
    rhythmbox
    standardnotes
    sublime-merge
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    qalculate-gtk
    todoist-electron
    typora
    pinta
    vlc
    vscode-with-extensions
    write_stylus
    zotero

    # Games
    minecraft

    # Languages & frameworks
    dart
    nixfmt
    texlive.combined.scheme-full
    texlab

    # Fonts
    corefonts # Microsoft core fonts for Web
    iosevka nerdfonts-iosevka
    inter-ui
    jetbrains-mono
    latinmodern-math
    roboto roboto-mono
    source-code-pro source-sans-pro source-serif-pro
    ubuntu_font_family

    # GTK
    equilux-theme
    pantheon.elementary-icon-theme
    pantheon.elementary-gtk-theme
    pantheon.elementary-sound-theme
  ];

  # Enabled programs and services (respective configs are in ./configurations)
  programs.alacritty.enable = true;
  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;
  programs.man.enable = true;
  programs.neovim.enable = true;
  programs.password-store.enable = true;
  programs.ptpython.enable = true;
  programs.tmux.enable = true;
  programs.zathura.enable = true;

  systemd.user.startServices = true;
  services.gpg-agent.enable = true;
  services.lorri.enable = true;
  services.onedrive.enable = true;
  services.udiskie.enable = true;

  xsession.enable = true;
  xsession.windowManager.i3.enable = true;

  # Todoist config
  home.file.".todoist.config.json".text = ''
    {
      "token": "${builtins.readFile ../secrets/todoist_api_token}",
      "color": "true"
    }
  '';

  # Fonts
  fonts.fontconfig.enable = true;
}
