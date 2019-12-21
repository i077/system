# Color scheme definitions.
# Each color scheme has two parts: color and scheme definitions.
# Color definitions are specific to the color scheme and define actual colors.
# Scheme definitions are read externally and are defined in terms of color definitions.
let
  gruvbox-dark = rec {
    # Color definitions
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

    # Scheme definitions
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

    vim-scheme = "gruvbox";
  };

  nord = {
    dark0 = "#2e3440";
    dark1 = "#3b4252";
    dark2 = "#434c5e";
    dark3 = "#4c566a";
    light0 = "#d8dee9";
    light1 = "#e5e9f0";
    light2 = "#eceff4";
    blue0 = "#8fbcbb";
    blue1 = "#88c0d0";
    blue2 = "#81a1c1";
    blue3 = "#5e81ac";
    red = "#bf616a";
    orange = "#d08770";
    yellow = "#ebcb8b";
    green = "#a3be8c";
    purple = "#b48ead";

    vim-scheme = "nord";
  };
in gruvbox-dark
