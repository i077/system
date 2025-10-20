{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.default
    ./plugins.nix
    ./completion.nix
    ./lsp.nix
  ];

  # Add configuration for Neovide
  xdg.configFile."neovide/config.toml".source = (pkgs.formats.toml {}).generate "neovide-config.toml" {
    multigrid = true;
  };

  lib.nvim = {
    # Helper function to create leader mappings under a prefix
    mkLeaderMappings = prefix:
      lib.mapAttrsToList (key: action: {
        key = "<Leader>${prefix}${key}";
        mode = ["n"];
        options.silent = true;
        inherit action;
      });
  };

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    # Set colorscheme
    extraConfigLuaPre = ''
      require('gruvbox').setup({
        italic = {
          strings = false,
        },
      })
    '';

    colorschemes.gruvbox.enable = true;

    opts = {
      # Mouse interaction
      mouse = "a";

      # Indentation -- 4 spaces per <Tab>
      tabstop = 4;
      expandtab = true;
      shiftwidth = 4;

      # Word wrap
      wrap = true;
      linebreak = true;

      # Show results of :substitute
      inccommand = "nosplit";

      # Searches are case-insensitive unless capital letter is present
      smartcase = true;

      # Preserve undo history across sessions
      undofile = true;

      # Don't start with all folds closed
      foldlevelstart = 99;

      # Font for GUI editors
      guifont = "Berkeley Mono:10";
    };

    # Show cursorline, but only on current window
    # via https://stackoverflow.com/a/12018552
    autoGroups.CursorLine = {};
    autoCmd = [
      {
        group = "CursorLine";
        event = ["VimEnter" "WinEnter" "BufWinEnter"];
        pattern = "*";
        command = "setlocal cursorline";
      }
      {
        group = "CursorLine";
        event = "WinLeave";
        pattern = "*";
        command = "setlocal nocursorline";
      }
    ];

    # Neovide options
    globals.neovide_cursor_trail_size = 0.3;
    globals.neovide_hide_mouse_when_typing = true;
    globals.neovide_input_macos_alt_is_meta = true;

    # Set leader
    globals.mapleader = " ";

    keymaps =
      [
        {
          key = " ";
          mode = ["n" "v"];
          options.silent = true;
          action = "<NOP>";
        }

        # Go to last buffer
        {
          key = "<leader><Tab>";
          mode = "n";
          action = "<C-^>";
        }

        # :write with ZW
        {
          key = "ZW";
          mode = "n";
          action = ":w<CR>";
        }

        # Quickly correct typos with <C-l>
        {
          key = "<C-l>";
          mode = "i";
          action = "<C-g>u<Esc>[s1z=`]a<C-g>u";
        }
      ]
      ++
      # Mappings to work with the OS clipboard
      (map (k: {
        key = "g${k}";
        mode = ["n" "v"];
        action = "\"+${k}";
      }) ["y" "p" "P"]);

    # Different indentation for various filetypes
    extraFiles = let
      indentTwoSpaces = ''
        setlocal tabstop=2
        setlocal shiftwidth=2
      '';
    in {
      "after/ftplugin/nix.vim".text = indentTwoSpaces;
      "after/ftplugin/terraform.vim".text = indentTwoSpaces;
      "after/ftplugin/typescript.vim".text = indentTwoSpaces;
    };
  };
}
