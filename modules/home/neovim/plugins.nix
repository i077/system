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

      # Focused writing
      plugins.goyo = {
        enable = true;
        width = 120;
      };

      # Statusline
      plugins.lualine = {
        enable = true;
        componentSeparators = {
          left = "";
          right = "";
        };
        sectionSeparators = {
          left = "";
          right = "";
        };
        iconsEnabled = false;

        sections = {
          # Only show the first char of the current mode
          lualine_a = [
            {
              name = "mode";
              extraConfig.fmt.__raw = "function(str) return str:sub(1,1) end";
            }
            "selectioncount"
          ];
          lualine_b = ["branch" "diff"];
          lualine_c = [
            {
              name = "filename";
              extraConfig.path = 1;
            }
          ];

          lualine_x = ["diagnostics" "filetype"];
          lualine_y = ["progress" "searchcount"];
          lualine_z = ["location"];
        };

        tabline = {
          lualine_a = [
            {
              name = "windows";
              extraConfig.windows_color = {
                active = "lualine_a_normal";
                inactive = "lualine_b_inactive";
              };
            }
          ];
          lualine_z = [
            {
              name = "tabs";
              extraConfig.tabs_color = {
                active = "lualine_a_normal";
                inactive = "lualine_b_inactive";
              };
            }
          ];
        };
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

    # File tree
    {
      plugins.nvim-tree.enable = true;

      # <C-h> to open/close file tree
      maps.normal."<C-h>" = {
        silent = true;
        action = ":NvimTreeToggle<CR>";
      };
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