{ config, pkgs, inputs, lib, ... }:

let
  inherit (builtins) readFile toJSON;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;

  cfg = config.modules.editors.neovim;

  inherit (config.nixpkgs) system;

  readVimSection = file: readFile (./. + "/${file}.vim");
  pluginWithCfg = name: {
    plugin = pkgs.vimPlugins.${name};
    config = readVimSection "plugins/${name}";
  };
in {
  options.modules.editors.neovim = {
    enable = mkEnableOption "Neovim editor";
    coc = {
      enable = mkEnableOption "Conquerer of completion for neovim";
      settings = mkOption {
        type = types.attrs;
        description = "Contents of coc-settings.json as an attribute set.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.neovim = {
        enable = true;

        # Use nightly version
        package = pkgs.neovim-nightly;

        vimAlias = true;
        vimdiffAlias = true;

        # Some plugins require Node and Python
        withNodeJs = true;
        withPython3 = true;

        plugins = with pkgs.vimPlugins; [
          # Editor
          sensible                          # Sensible defaults
          repeat                            # Repeatable plugin actions
          surround                          # Surround text
          commentary                        # Comment code with 'gcc'
          easy-align                        # Alignment plugin
          (pluginWithCfg "easymotion")      # Enhanced motions
          vim-indent-object                 # Use indents as motions
          (pluginWithCfg "undotree")        # Visualize the undo tree

          # Extensions
          direnv-vim                        # Direnv integration
          (pluginWithCfg "fugitive")        # Git wrapper
          rhubarb                           # :GBrowse for GitHub
          fugitive-gitlab-vim               #           ...Gitlab
          (pluginWithCfg "vim-dispatch")    # Asynchronous job runner
          (pluginWithCfg "fzf-vim")         # Fuzzy entry selection
          (pluginWithCfg "denite-nvim")     # Async unite interface
          nvim-yarp                         # Remote plugin framework
          auto-session                      # Auto-save and restore sessions

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
          {                                 # Multiple language support
            plugin = polyglot; 
            optional = true;
            config = ''
              " Disable languages other plugins handle better
              let g:polyglot_disabled = ['tex', 'latex']
              packadd! vim-polyglot
            '';
          }
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

    (mkIf cfg.coc.enable {
      hm.programs.neovim = {
        plugins = with pkgs.vimPlugins; [ (pluginWithCfg "coc-nvim") coc-git ];
      };

      hm.xdg.configFile."nvim/coc-settings.json".text = toJSON cfg.coc.settings;
    })

    # Python-specific stuff
    (mkIf config.modules.devel.python.enable {
      hm.programs.neovim = {
        # Add Python development tools
        extraPython3Packages = (ps: with ps; [ black jedi pylint python-language-server ]);
        plugins = with pkgs.vimPlugins; if cfg.coc.enable then [ coc-python ] else [ ];
      };
    })

    # LaTeX-specific stuff
    (mkIf config.modules.devel.latex.enable {
      hm.programs.neovim.plugins = with pkgs.vimPlugins;
        if cfg.coc.enable then [ (pluginWithCfg "vimtex") coc-vimtex ] else [ ];
    })

    # Nix-specific stuff
    (mkIf config.modules.devel.nix.enable {
      modules.editors.neovim.coc.settings.languageserver = {
        nix = {
          command = let rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            in "${rnix-lsp}/bin/rnix-lsp";
          filetypes = [ "nix" ];
        };
      };
    })
  ]);
}
