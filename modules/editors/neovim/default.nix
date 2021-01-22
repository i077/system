{ config, pkgs, lib, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.modules.editors.neovim;

  readVimSection = file: readFile (./. + "/${file}.vim");
  pluginWithCfg = name: {
    plugin = pkgs.vimPlugins.${name};
    config = readVimSection "plugins/${name}";
  };
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
          sensible                          # Sensible defaults
          repeat                            # Repeatable plugin actions
          surround                          # Surround text
          commentary                        # Comment code with 'gcc'
          easy-align                        # Alignment plugin
          (pluginWithCfg "easymotion")      # Enhanced motions
          vim-indent-object                 # Use indents as motions

          # Extensions
          direnv-vim                        # Direnv integration
          (pluginWithCfg "fugitive")        # Git wrapper
          (pluginWithCfg "vim-dispatch")    # Asynchronous job runner
          (pluginWithCfg "fzf-vim")         # Fuzzy entry selection
          (pluginWithCfg "denite-nvim")     # Async unite interface
          nvim-yarp                         # Remote plugin framework

          # UI + Colorschemes
          (pluginWithCfg "airline")         # Smarter tabline
          vim-airline-themes                # Airline themes (automatches colorscheme)
          base16-vim                        # Base16
          falcon                            # Falcon
          vim-monokai-pro                   # Monokai Pro
          awesome-vim-colorschemes          # Collection of colorschemes
          solarized                         # Solarized

          # Languages
          (pluginWithCfg "ale")             # Async linting framework
          (pluginWithCfg "coc-nvim")        # Conquerer of Completion (VSCode-based completion)
          coc-git                           # Git gutter
          polyglot                          # Multiple language support
          vim-addon-nix                     # Nix language support
          vim-pandoc                        # Pandoc support
          vim-pandoc-syntax                 # Pandoc syntax support
          (pluginWithCfg "vim-slime")       # Scheme support

          # Prose
          goyo                              # Distraction-free editing
          limelight-vim                     # Focus mode for vim
          (pluginWithCfg "vim-pencil")      # Writing tool for vim
        ];

        extraConfig = ''
          ${readVimSection "editor"}
          ${readVimSection "ui"}
          ${readVimSection "mappings"}
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
        (pluginWithCfg "vimtex")
        coc-vimtex
      ];
    })
  ]);
}
