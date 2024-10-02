{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.nvim) mkLeaderMappings;
in {
  programs.nixvim = lib.mkMerge [
    {
      # Syntax highlighting using tree-sitter
      plugins.treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        settings = {
          incremental_selection.enable = true;
          indent.enable = true;
        };
      };

      # Show code context, e.g. what function current line is under
      plugins.treesitter-context = {
        enable = true;
        settings = {
          max_lines = 2;
          min_window_height = 100;
        };
      };

      # Comments
      plugins.comment.enable = true;

      # Automatic session management
      plugins.auto-session = {
        enable = true;
        cwdChangeHandling = {};
      };
      # Map to :Telescope for sessions
      keymaps = [
        {
          key = "<leader>fs";
          options.silent = true;
          action.__raw = "require('auto-session.session-lens').search_session";
        }
      ];

      # f/t but with two characters
      plugins.leap.enable = true;

      # Surrounds
      plugins.vim-surround.enable = true;

      # Better folds
      plugins.nvim-ufo.enable = true;

      # Keymap hints
      plugins.which-key.enable = true;

      # Autopairs
      plugins.nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          map_bs = true;
          map_c_w = true;
        };
      };

      # Focused writing
      plugins.goyo = {
        enable = true;
        settings.width = 120;
      };

      # Statusline
      plugins.lualine = {
        enable = true;

        settings = {
          options = {
            componentSeparators = {
              left = "";
              right = "";
            };
            sectionSeparators = {
              left = "";
              right = "";
            };
            iconsEnabled = false;
          };

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
      };

      # Extra plugins that aren't yet in nixvim
      extraPlugins = with pkgs.vimPlugins; [
        sensible # Sensible defaults
        repeat # Repeatable plugin actions
        easy-align # Align text around symbols
        direnv-vim # Direnv integration
      ];
    }

    # mini.nvim
    {
      plugins.mini.enable = true;
      plugins.mini.modules = {
        # Enhanced textobjects
        ai = {};
        # Text alignment
        align = {};
        # Window-preserving buffer deletion
        bufremove = {};
      };
    }

    # Telescope picker
    {
      plugins.telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = "find_files";
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>f:" = "commands";
          "<leader>fq" = "quickfix";
          "<leader>fr" = "oldfiles";
          "<leader>fd" = "diagnostics";
        };
      };

      plugins.web-devicons.enable = true;
    }

    # Visualize the undo tree
    {
      plugins.undotree.enable = true;
      keymaps = [
        {
          key = "<F5>";
          mode = ["n"];
          action = ":UndotreeToggle<CR>";
        }
      ];
    }

    # File tree
    {
      plugins.nvim-tree.enable = true;

      # <C-h> to open/close file tree
      keymaps = [
        {
          key = "<C-h>";
          mode = ["n"];
          options.silent = true;
          action = ":NvimTreeToggle<CR>";
        }
      ];
    }

    # Git integration w/ vim-fugitive
    {
      plugins.fugitive.enable = true;

      # Create mappings under <Leader>g
      keymaps = mkLeaderMappings "g" {
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

    # Live LaTeX editing
    {
      plugins.texpresso.enable = true;
    }
  ];
}
