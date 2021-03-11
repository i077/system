{ config, pkgs, inputs, lib, ... }:

let
  inherit (builtins) listToAttrs readFile toJSON;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption nameValuePair types;

  cfg = config.modules.editors.neovim;

  inherit (config.nixpkgs) system;

  readVimSection = file: readFile (./. + "/${file}.vim");
  pluginWithCfg = plugin: {
    inherit plugin;
    config = readVimSection "plugins/${plugin.pname}";
  };

  # For plugins configured with lua
  wrapLuaConfig = luaConfig: ''
    lua<<EOF
    ${luaConfig}
    EOF
  '';
  readLuaSection = file: wrapLuaConfig (readFile (./. + "/${file}.lua"));
  pluginWithLua = plugin: {
    inherit plugin;
    config = readLuaSection "plugins/${plugin.pname}";
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
          (pluginWithCfg easymotion)        # Enhanced motions
          vim-indent-object                 # Use indents as motions
          (pluginWithCfg undotree)          # Visualize the undo tree

          # Extensions
          direnv-vim                        # Direnv integration
          (pluginWithCfg fugitive)          # Git wrapper
          rhubarb                           # :GBrowse for GitHub
          fugitive-gitlab-vim               #           ...Gitlab
          (pluginWithCfg vim-dispatch)      # Asynchronous job runner
          (pluginWithCfg fzf-vim)           # Fuzzy entry selection
          (pluginWithCfg denite-nvim)       # Async unite interface
          nvim-yarp                         # Remote plugin framework
          auto-session                      # Auto-save and restore sessions

          # UI + Colorschemes
          (pluginWithCfg airline)           # Smarter tabline
          vim-airline-themes                # Airline themes (automatches colorscheme)
          base16-vim                        # Base16
          falcon                            # Falcon
          vim-monokai-pro                   # Monokai Pro
          awesome-vim-colorschemes          # Collection of colorschemes
          solarized                         # Solarized

          # Languages
          (pluginWithLua nvim-treesitter)   # Better (AST-based) language parsing
          nvim-treesitter-textobjects       # ...with text objects
          (pluginWithCfg ale)               # Async linting framework
          (pluginWithCfg coc-nvim)          # Conquerer of Completion (VSCode-based completion)
          coc-git                           # Git gutter
          (pluginWithCfg polyglot // {      # Multiple language support
            optional = true;
          })
          vim-addon-nix                     # Nix language support
          vim-pandoc                        # Pandoc support
          vim-pandoc-syntax                 # Pandoc syntax support
          (pluginWithCfg vim-slime)         # Scheme support

          # Prose
          goyo                              # Distraction-free editing
          limelight-vim                     # Focus mode for vim
          (pluginWithCfg vim-pencil)        # Writing tool for vim
        ];

        extraConfig = ''
          ${readVimSection "editor"}
          ${readVimSection "ui"}
          ${readVimSection "mappings"}
          ${readVimSection "functions"}
        '';
      };

      hm.home.packages = with pkgs; [ ctags neovim-remote ];

      # Treesitter grammars
      hm.xdg.configFile = let
        # The languages for which I want to use tree-sitter
        languages = [ "lua" "nix" "python" ];
        # Map each language to its respective tree-sitter package
        grammarPkg = l: pkgs.tree-sitter.builtGrammars.${"tree-sitter-" + l};
        # Map each language to a name-value pair for xdg.configFile
        langToFile = lang: nameValuePair "nvim/parser/${lang}.so" {
          source = "${grammarPkg lang}/parser";
        };
        # The final collection of name-value pairs
        files = map langToFile languages;
      in listToAttrs files;
    }

    (mkIf cfg.coc.enable {
      hm.programs.neovim = {
        plugins = with pkgs.vimPlugins; [ (pluginWithCfg coc-nvim) coc-git ];
      };

      hm.xdg.configFile."nvim/coc-settings.json".text = toJSON cfg.coc.settings;
    })

    # Python-specific stuff
    (mkIf config.modules.devel.python.enable {
      hm.programs.neovim = {
        # Add Python development tools
        plugins = with pkgs.vimPlugins; if cfg.coc.enable then [ coc-pyright ] else [ ];
      };
    })

    # LaTeX-specific stuff
    (mkIf config.modules.devel.latex.enable {
      hm.programs.neovim.plugins = with pkgs.vimPlugins;
        if cfg.coc.enable then [ (pluginWithCfg vimtex) coc-vimtex ] else [ ];
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
