{pkgs, ...}: let
  inherit (builtins) readFile;

  readVimSection = file: readFile (./. + "/${file}.vim");
  pluginWithCfg = plugin: {
    inherit plugin;
    type = "viml";
    config = readVimSection "plugins/${plugin.pname}";
  };

  # For plugins configured with lua
  readLuaSection = file: readFile (./. + "/${file}.lua");
  pluginWithLua = plugin: {
    inherit plugin;
    type = "lua";
    config = readLuaSection "plugins/${plugin.pname}";
  };
in {
  programs.neovim = {
    enable = false;

    # Set aliases
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [neovim-remote];

    plugins = with pkgs.vimPlugins; [
      # Editor
      sensible # Sensible defaults
      repeat # Repeatable plugin actions
      surround # Surround text
      commentary # Comment code with 'gcc'
      easy-align # Alignment plugin
      (pluginWithLua leap-nvim) # Enhanced motions
      (pluginWithLua leap-ast-nvim) # Leap with tree-sitter nodes
      vim-indent-object # Use indents as motions
      (pluginWithCfg undotree) # Visualize the undo tree
      vim-nixhash # Automated TOFU hash fetching for Nix derivations

      # Extensions
      (pluginWithCfg vim-fugitive) # Git integration
      direnv-vim # Direnv integration
      plenary-nvim # Library of Lua functions
      (pluginWithCfg telescope-nvim) # Fuzzy entry selection
      (pluginWithCfg nerdtree) # File browser
      (pluginWithLua toggleterm-nvim) # Easier :terminal management
      (pluginWithLua firenvim) # Use nvim for textareas in the browser

      # Syntax
      vim-polyglot # A bunch of languages
      (pluginWithLua nvim-treesitter.withAllGrammars) # Better (AST-based) language parsing
      # See ./lsp for nvim-lspconfig configuration
      (pluginWithLua lspsaga-nvim) # LSP UI
      (pluginWithLua trouble-nvim) # Add LSP diagnostics to quickfix list

      # Autocomplete
      (pluginWithLua nvim-cmp) # Auto-completion
      cmp-nvim-lsp # LSP completion source
      # cmp-git # Git/GitHub completion source
      cmp-buffer # Suggest completions from the current buffer
      cmp-cmdline # Completions for :
      cmp-path # Filepath completion source

      # Writing
      (pluginWithCfg vim-pencil) # Better prose support
      goyo # Focused writing

      # UI
      base16-vim # Base16
      falcon # Falcon
      vim-monokai-pro # Monokai Pro
      awesome-vim-colorschemes # Collection of colorschemes
      (pluginWithLua lualine-nvim) # A nicer statusline
    ];

    extraConfig = ''
      ${readVimSection "editor"}
      ${readVimSection "ui"}
      ${readVimSection "mappings"}
      ${readVimSection "functions"}
      if exists('g:vscode')
        syntax off
      else
        colorscheme nord
      endif
    '';
  };

  # LSP
  imports = [./lsp];

  programs.nixvim = {
    enable = true;

    # Set colorscheme
    colorschemes.nord.enable = true;
  };
}
