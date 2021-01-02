{ config, pkgs, lib, ... }:

let
  cfg = config.modules.editors.neovim;
  inherit (lib) mkEnableOption mkIf mkMerge;

  readVimSection = file: builtins.readFile (./. + "/${file}.vim");
in {
  options.modules.editors.neovim = {
    enable = mkEnableOption "Neovim editor";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.neovim = {
        enable = true;
        vimAlias = true;
        vimdiffAlias = true;

        # Some plugins require Node and Python
        withNodeJs = true;
        withPython3 = true;

        # TODO separate plugin config
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
          direnv-vim                    # Direnv integration
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
          coc-nvim                      # Conquerer of Completion (VSCode-based completion)
          coc-git                       # Git gutter
          polyglot                      # Multiple language support
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
          color ${config.modules.theming.vimColorscheme}
          ${readVimSection "editor"}
          ${readVimSection "ui"}
          ${readVimSection "mappings"}
          ${readVimSection "syntax"}
          ${readVimSection "functions"}
        '';
      };

      hm.home.packages = with pkgs; [ ctags neovim-remote ];
    }

    # Python-specific stuff
    (mkIf config.modules.devel.python.enable {
      hm.programs.neovim = {
        # Add Python development tools
        extraPython3Packages = (ps: with ps; [ black jedi pylint python-language-server ]);
        plugins = with pkgs.vimPlugins; [ coc-python ];
      };
    })

    # LaTeX-specific stuff
    (mkIf config.modules.devel.latex.enable {
      hm.programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = pkgs.vimPlugins.vimtex;
          config = readVimSection "vimtex";
        }
        coc-vimtex
      ];
    })
  ]);
}
