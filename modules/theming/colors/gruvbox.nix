{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.theming;
in mkIf (cfg.colorscheme == "gruvbox") {
  modules.theming.colors = let
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

  # fish
  hm.programs.fish = {
    plugins = [{
      name = "gruvbox";
      src = inputs.fish-gruvbox;
    }];
    promptInit = ''
      theme_gruvbox dark hard
    '';
  };

  # neovim
  hm.programs.neovim = {
    # Colorscheme is in awesome-vim-colorschemes
    extraConfig = ''
      color gruvbox
    '';
  };

  # git delta
  hm.programs.git.delta.options.syntax-theme = "gruvbox";

  # bat
  hm.programs.bat = {
    config.theme = "gruvbox";

    # Provide gruvbox theme from upstream
    themes = {
      gruvbox = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "peaceant";
        repo = "gruvbox";
        rev = "e3db74d0e5de7bc09cab76377723ccf6bcc64e8c";
        hash = "sha256-gsk3qdx+OHMvaOVOlbTapqp8iakA350yWT9Jf08uGoU=";
      } + "/gruvbox.tmTheme");
    };
  };

  # kitty
  hm.programs.kitty = {
    extraConfig = ''
      # hard contrast
      background    #1d2021

      # medium contrast
      # background    #282828

      # soft contrast
      # background    #32302f

      foreground    #ebdbb2
      cursorColor   #ebdbb2

      color0        #282828
      color1        #cc241d
      color2        #98971a
      color3        #d79921
      color4        #458588
      color5        #b16286
      color6        #689d6a
      color8        #928374
      color7        #a89984
      color9        #fb4934
      color10       #b8bb26
      color11       #fabd2f
      color12       #83a598
      color13       #d3869b
      color14       #8ec07c
      color15       #ebdbb2
    '';
  };
}
