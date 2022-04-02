{ lib, pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (lib) mkBefore;

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
  programs.neovim = {
    enable = true;

    # Set aliases
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [ neovim-remote ];

    plugins = with pkgs.vimPlugins; [
      # Editor
      sensible # Sensible defaults
      repeat # Repeatable plugin actions
      surround # Surround text
      commentary # Comment code with 'gcc'
      easy-align # Alignment plugin
      lightspeed-nvim # Enhanced motions
      vim-indent-object # Use indents as motions
      (pluginWithCfg undotree) # Visualize the undo tree

      # Extensions
      direnv-vim # Direnv integration

      # Syntax
      (pluginWithLua nvim-treesitter) # Better (AST-based) language parsing

      # UI
      base16-vim # Base16
      falcon # Falcon
      vim-monokai-pro # Monokai Pro
      awesome-vim-colorschemes # Collection of colorschemes
    ];

    extraConfig = ''
      colorscheme falcon
    '';
  };

  xdg.configFile."nvim/init.vim".text = mkBefore ''
    ${readVimSection "editor"}
    ${readVimSection "ui"}
    ${readVimSection "mappings"}
    ${readVimSection "functions"}
  '';

  # Treesitter parsers
  xdg.configFile."nvim/parser".source =
    pkgs.tree-sitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
}
