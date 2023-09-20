{
  lib,
  pkgs,
  ...
}: {
  imports = [./plugins.nix ./completion.nix ./lsp.nix];

  # Add configuration for Neovide
  xdg.configFile."neovide/config.toml".source = (pkgs.formats.toml {}).generate "neovide-config.toml" {
    multigrid = true;
  };

  lib.nixvim = {
    # Helper function to create leader mappings under a prefix
    mkLeaderMappings = prefix:
      lib.mapAttrs' (key: action:
        lib.nameValuePair "<Leader>${prefix}${key}" {
          silent = true;
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

    options = {
      # Mouse interaction
      mouse = "a";

      # Indentation
      tabstop = 4;
      softtabstop = 4;
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

    # Set leader
    globals.mapleader = " ";
    maps.normalVisualOp." " = {
      action = "<NOP>";
      silent = true;
    };

    # Go to last buffer
    maps.normal."<leader><Tab>" = "<C-^>";

    # Neovide options
    globals.neovide_cursor_trail_size = 0.3;
    globals.neovide_hide_mouse_when_typing = true;
    globals.neovide_input_macos_alt_is_meta = true;

    # :write with ZW
    maps.normal."ZW".action = ":w<CR>";

    # <Tab> through completions
    maps.insert."<Tab>" = {
      expr = true;
      action = ''pumvisible() ? "\<C-n>" : "\<Tab>"'';
    };
    maps.insert."<S-Tab>" = {
      expr = true;
      action = ''pumvisible() ? "\<C-p>" : "\<S-Tab>"'';
    };

    # Mappings to work with the OS clipboard
    maps.normalVisualOp."gy" = "\"+y";
    maps.normalVisualOp."gp" = "\"+p";
    maps.normalVisualOp."gP" = "\"+P";

    # Quickly correct typos (and create new undo point)
    maps.insert."<C-l>".action = "<C-g>u<Esc>[s1z=`]a<C-g>u";
  };
}
