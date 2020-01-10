{ config, pkgs, ... }:

let
  custompkgs = import ../packages {};
  nerdfonts-iosevka = let version = "2.0.0"; in pkgs.fetchzip rec {
    name = "nerdfonts-iosevka";

    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Iosevka.zip";

    sha256 = "1b8agwll5safqzxcf80sinxwhgqmrh3jh2arvskshvll29dzigp2";

    postFetch = ''
      mkdir -p $out/share/fonts
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    '';
  };
in
{
  imports = with builtins;
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations));

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Allow unfree software
  nixpkgs.config = {
    allowUnfree = true;

    packageOverrides = pkgs: rec {
      unstable = import <unstable> { config.allowUnfree = true; };
      alacritty = unstable.alacritty;
    };
  };

  # User packages
  home.packages = with pkgs.unstable; [
    # Command-line utilities
    python3Packages.black
    ctags
    exa
    gnumake
    gopass
    hugo
    pandoc
    passff-host
    pinentry
    pipenv
    pypi2nix
    ranger
    todoist
    tomb
    neovim-remote
    xsel

    # Apps
    android-studio
    brscan4
    gnome3.geary
    libreoffice-fresh
    nasc
    rhythmbox
    standardnotes
    sublime-merge
    jetbrains.idea-community
    jetbrains.pycharm-community
    qalculate-gtk
    qt5.qtbase
    gnome3.sushi
    typora
    pinta
    vlc
    vscode-with-extensions
    custompkgs.write_stylus
    zotero

    # Games
    minecraft

    # Languages
    dart
    texlive.combined.scheme-full
    texlab

    # Fonts
    corefonts # Microsoft core fonts for Web
    iosevka nerdfonts-iosevka
    inter-ui
    roboto roboto-mono
    ubuntu_font_family

    # Python packages
    python3Packages.powerline
    python3Packages.pylint

    # Node packages
    nodePackages.neovim

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
  programs.tmux.enable = true;
  programs.zathura.enable = true;

  systemd.user.startServices = true;
  services.gpg-agent.enable = true;
  services.lorri.enable = true;
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
