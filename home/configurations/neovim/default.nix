{ config, lib, pkgs, ... }:

let
  colors = import ../../colors.nix;
  readVimSection = file: builtins.readFile (./. + "/${file}.vim");
in lib.mkIf config.programs.neovim.enable {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # Editor
      sensible                      # Sensible defaults
      repeat                        # Repeatable plugin actions
      surround                      # Surround text
      commentary                    # Comment code with 'gcc'
      easy-align                    # Alignment plugin
      easymotion                    # Enhanced motions
      vim-indent-object             # Use indents as motions

      # Extensions
      fugitive                      # Git wrapper
      vim-dispatch                  # Asynchronous job runner
      fzf-vim                       # Fuzzy entry selection
      denite-nvim                   # Async unite interface
      nvim-yarp                     # Remote plugin framework

      # UI + Colorschemes
      airline                       # Smarter tabline
      vim-airline-themes            # Airline themes (automatches colorscheme)
      base16-vim                    # Base16
      falcon                        # Falcon
      vim-monokai-pro               # Monokai Pro
      awesome-vim-colorschemes      # Collection of colorschemes
      solarized                     # Solarized

      # Languages
      ale                           # Async linting framework
      # deoplete-nvim                 # Dark-powered async completion framework
      # LanguageClient-neovim       # Integrations with language servers, used with deoplete
      coc-nvim                      # Conquerer of Completion (VSCode-based completion)
      polyglot                      # Multiple language support
      vimtex                        # LaTeX support
      vim-addon-nix                 # Nix language support
      vim-pandoc                    # Pandoc support
      vim-pandoc-syntax             # Pandoc syntax support
      vim-slime                     # Scheme support

      # Prose
      goyo                          # Distraction-free editing
      limelight-vim                 # Focus mode for vim
      vim-pencil                    # Writing tool for vim
    ];

    extraConfig = ''
      ${readVimSection "editor"}
      ${readVimSection "ui"}
      ${readVimSection "mappings"}
      ${readVimSection "syntax"}
      ${readVimSection "functions"}

      "" Set colorscheme from colors.nix
      colorscheme ${colors.vim-scheme}

      " Remove background from conceal chars
      hi Conceal guibg=None
    '';
  };

  # Add node package
  home.packages = [ pkgs.nodePackages.neovim ];
}
