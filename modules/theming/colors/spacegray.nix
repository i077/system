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
      background            #111314
      foreground            #b7bbb7
      cursor                #b7bbb7
      selection_background  #15171e
      selection_foreground  #111314
      color0                #2c2f33
      color8                #4b5056
      color1                #b04c50
      color9                #b04c50
      color2                #919652
      color10               #94985b
      color3                #e2995c
      color11               #e2995c
      color4                #66899d
      color12               #66899d
      color5                #8d6494
      color13               #8d6494
      color6                #527c77
      color14               #527c77
      color7                #606360
      color15               #dde3dc
    '';
  };
}
