{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.modules.desktop;
  inherit (lib) mapAttrsToList mkIf;

  isHiDPI = config.modules.hardware.video.hidpi.enable;
in mkIf config.services.xserver.enable {
  assertions = [{
    # TODO
    assertion = true;
    message = "No more than one desktop environment can be enabled at the same time.";
  }];

  services.xserver.layout = "us";

  hm.home.packages = with pkgs; [
    # No point in having these without a desktop...
    maim
    xdotool
    xsel

    pandoc

    # GUI apps
    amazing-marvin
    feedreader
    libreoffice-fresh
    obsidian
    qalculate-gtk
    quodlibet-full
    ripcord
    vlc
    write_stylus
    zoom-us # For now...
    zotero
  ];

  # Fonts
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs;
      [
        corefonts # Microsoft core fonts for Web
        iosevka
        (nerdfonts.override (_: { fonts = [ "JetBrainsMono" ]; }))
        ia-writer-duospace
        inter
        latinmodern-math
        open-sans
        roboto
        roboto-mono
        source-code-pro
        source-sans-pro
        source-serif-pro
        ubuntu_font_family
      ] ++ (mapAttrsToList (_: v: v.pkg) config.modules.theming.fonts);

    fontconfig = {
      enable = true;
      defaultFonts = with config.modules.theming.fonts; {
        monospace = [ mono.family ];
        sansSerif = [ sans.family ];
        serif = [ serif.family ];
      };
    };
  };

  hm.fonts.fontconfig.enable = true;

  # Cursor
  hm.xsession.pointerCursor = {
    package = pkgs.pantheon.elementary-icon-theme;
    name = "elementary";
    size = 24 * (if isHiDPI then 2 else 1);
  };
}
