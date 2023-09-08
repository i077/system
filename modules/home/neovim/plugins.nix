{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.nixvim) mkLeaderMappings;
in {
  programs.nixvim = lib.mkMerge [
    {
      # Syntax highlighting using tree-sitter
      plugins.treesitter = {
        enable = true;
        folding = true;
        indent = true;
        nixvimInjections = true;
        incrementalSelection.enable = true;
      };

      # Show code context, e.g. what function current line is under
      plugins.treesitter-context = {
        enable = true;
        maxLines = 2;
        minWindowHeight = 100;
      };

      # Comments
      plugins.comment-nvim.enable = true;

      # Automatic session management
      plugins.auto-session.enable = true;

      # f/t but with two characters
      plugins.leap.enable = true;

      # Better folds
      plugins.nvim-ufo.enable = true;

      # Keymap hints
      plugins.which-key.enable = true;

      # Autopairs
      plugins.nvim-autopairs = {
        enable = true;
        checkTs = true;
        mapBs = true;
        mapCW = true;
      };

      # Extra plugins that aren't yet in nixvim
      extraPlugins = with pkgs.vimPlugins; [
        sensible # Sensible defaults
        repeat # Repeatable plugin actions
        easy-align # Align text around symbols
        direnv-vim # Direnv integration
      ];
    }
    # Visualize the undo tree
    {
      plugins.undotree.enable = true;
      maps.normal."<F5>" = ":UndotreeToggle<CR>";
    }
    # Git integration w/ vim-fugitive
    {
      plugins.fugitive.enable = true;

      # Create mappings under <Leader>g
      maps.normal = mkLeaderMappings "g" {
        "s" = ":Git<CR>";
        "l" = ":Git log --oneline --graph<CR>";
        "L" = ":Gclog<CR>";
        "d" = ":Gdiffsplit<CR>";
        "b" = ":Git blame<CR>";

        "c" = ":Git commit<CR>";
        "C" = ":Git commit %<CR>";
        "A" = ":Git commit --amend<CR>";

        "f" = ":Git fetch<CR>";
        "p" = ":Git push<CR>";
        "P" = ":Git pull<CR>";

        "w" = ":Gwrite<CR>";
      };
    }
  ];
}
