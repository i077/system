# modules/themes/colorschemes.nix -- Defines a bunch of 16-color palettes.

{ lib, ... }:

let inherit (lib) mkOption types;
in {
  options.modules.theming.colorschemes = mkOption {
    description = "Attribute set of colorschemes.";
    type = types.attrs;
    internal = true;
  };

  config.modules.theming.colorschemes = {
    gotham = let
      c-base0 = "#0c1014";
      c-base1 = "#11151c";
      c-base2 = "#091f2e";
      c-base3 = "#0a3749";
      c-base4 = "#245361";
      c-base5 = "#599cab";
      c-base6 = "#99d1ce";
      c-base7 = "#d3ebe9";
      c-red = "#c23127";
      c-orange = "#d26937";
      c-yellow = "#edb443";
      c-magenta = "#888ca6";
      c-violet = "#4e5166";
      c-blue = "#195466";
      c-cyan = "#33859e";
      c-green = "#2aa889";
    in {
      bg0 = c-base0;
      bg1 = c-base1;
      bg2 = c-base2;
      bg3 = c-base3;
      fg0 = c-base7;
      fg1 = c-base6;
      fg2 = c-base5;
      fg3 = c-base4;
      alert = c-red;
      primary = c-cyan;
      secondary = c-green;
      tertiary = c-violet;
      quaternary = c-orange;
      quinary = c-yellow;
      senary = c-magenta;
      septary = c-blue;
    };

    gruvbox-dark = let
      c-bg = "#282828";
      c-bg1 = "#3c3836";
      c-bg2 = "#504945";
      c-bg3 = "#665c54";
      c-bg4 = "#7c6f64";
      c-fg = "#fbf1c7";
      c-fg1 = "#ebdbb2";
      c-fg2 = "#d5c4a1";
      c-fg3 = "#bdae93";
      c-fg4 = "#a89984";
      c-gray = "#928374";
      c-red = "#fb4934";
      c-green = "#b8bb26";
      c-yellow = "#fabd2f";
      c-blue = "#83a598";
      c-purple = "#d3869b";
      c-aqua = "#8ec07c";
      c-orange = "#fe8019";
    in {
      bg0 = c-bg;
      bg1 = c-bg1;
      bg2 = c-bg2;
      bg3 = c-bg3;
      fg0 = c-fg;
      fg1 = c-fg1;
      fg2 = c-fg2;
      fg3 = c-fg3;
      alert = c-red;
      primary = c-gray;
      secondary = c-green;
      tertiary = c-purple;
      quaternary = c-orange;
      quinary = c-yellow;
      senary = c-blue;
      septary = c-aqua;
    };

    nord = let
      c-dark0 = "#2e3440";
      c-dark1 = "#3b4252";
      c-dark2 = "#434c5e";
      c-dark3 = "#4c566a";
      c-light0 = "#eceff4";
      c-light1 = "#e5e9f0";
      c-light2 = "#d8dee9";
      c-blue0 = "#8fbcbb";
      c-blue1 = "#88c0d0";
      c-blue2 = "#81a1c1";
      c-blue3 = "#5e81ac";
      c-red = "#bf616a";
      c-orange = "#d08770";
      c-yellow = "#ebcb8b";
      c-green = "#a3be8c";
      c-purple = "#b48ead";
    in {
      bg0 = c-dark0;
      bg1 = c-dark1;
      bg2 = c-dark2;
      bg3 = c-dark3;
      fg0 = c-light0;
      fg1 = c-light1;
      fg2 = c-light2;
      fg3 = c-blue2;
      alert = c-red;
      primary = c-blue1;
      secondary = c-green;
      tertiary = c-purple;
      quaternary = c-orange;
      quinary = c-yellow;
      senary = c-blue3;
      septary = c-blue0;
    };

    oceanicnext = let
      c-dark0 = "#1b2b34";
      c-dark1 = "#343d46";
      c-dark2 = "#4f5b66";
      c-dark3 = "#65737e";
      c-light0 = "#d8dee9";
      c-light1 = "#cdd3de";
      c-light2 = "#c0c5ce";
      c-light3 = "#a7adba";
      c-red = "#ec5f67";
      c-orange = "#f99157";
      c-yellow = "#fac863";
      c-green = "#99c794";
      c-aqua = "#5fb3b3";
      c-blue = "#6699cc";
      c-purple = "#c594c5";
      c-brown = "#ab7967";
    in {
      bg0 = c-dark0;
      bg1 = c-dark1;
      bg2 = c-dark2;
      bg3 = c-dark3;
      fg0 = c-light0;
      fg1 = c-light1;
      fg2 = c-light2;
      fg3 = c-light3;
      alert = c-red;
      primary = c-blue;
      secondary = c-green;
      tertiary = c-purple;
      quaternary = c-orange;
      quinary = c-yellow;
      senary = c-aqua;
      septary = c-brown;
    };
  };
}
