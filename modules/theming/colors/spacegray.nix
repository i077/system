{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.theming;
in mkIf (cfg.colorscheme == "spacegray") {
  # Spacegray is really base16-ocean
  modules.theming.colors = let
    base03 = "#2B303B";
    base02 = "#343D46";
    base01 = "#4F5B66";
    base00 = "#65737E";
    base0 = "#A7ADBA";
    base1 = "#C0C5CE";
    base2 = "#DFE1E8";
    base3 = "#EFF1F5";

    yellow = "#EBCB8B";
    orange = "#D08770";
    red = "#BF616A";
    magenta = "#AB7967";
    violet = "#B48EAD";
    blue = "#8FA1B3";
    cyan = "#96B5B4";
    green = "#A3BE8C";
  in {
    bg0 = base03;
    bg1 = base02;
    bg2 = base01;
    bg3 = base00;
    fg0 = base0;
    fg1 = base1;
    fg2 = base2;
    fg3 = base3;
    alert = red;
    primary = blue;
    secondary = green;
    tertiary = violet;
    quaternary = orange;
    quinary = yellow;
    senary = magenta;
    septary = cyan;
  };

  # neovim
  hm.programs.neovim = {
    # colorscheme is provided in base16
    extraConfig = ''
      color base16-ocean
    '';
  };

  # git delta
  # delta reads themes from bat
  hm.programs.git.delta.options.syntax-theme = "base16-ocean";

  # bat
  hm.programs.bat = {
    config.theme = "base16-ocean";

    # Provide base16 theme from spacegray repo
    themes = {
      base16-ocean = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "kkga";
        repo = "spacegray";
        rev = "8d4a59de254a27cc7c588c07a6a86662c0cf48d8";
        hash = "sha256-mh6eIKpB8Qx2uzcRBR7s6B80inwQR0xywHeRTW3lycM=";
      } + "/base16-ocean.dark.tmTheme");
    };
  };

  # kitty
  hm.programs.kitty = {
    extraConfig = ''
      background #2b303b
      foreground #c0c5ce
      selection_background #c0c5ce
      selection_foreground #2b303b
      url_color #a7adba
      cursor #c0c5ce
      active_border_color #65737e
      inactive_border_color #343d46
      active_tab_background #2b303b
      active_tab_foreground #c0c5ce
      inactive_tab_background #343d46
      inactive_tab_foreground #a7adba
      tab_bar_background #343d46

      # normal
      color0 #2b303b
      color1 #bf616a
      color2 #a3be8c
      color3 #ebcb8b
      color4 #8fa1b3
      color5 #b48ead
      color6 #96b5b4
      color7 #c0c5ce

      # bright
      color8 #65737e
      color9 #d08770
      color10 #343d46
      color11 #4f5b66
      color12 #a7adba
      color13 #dfe1e8
      color14 #ab7967
      color15 #eff1f5
    '';
  };
}
