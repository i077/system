{config, ...}: let
  inherit (config.lib.nvim) mkLeaderMappings;
in {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      servers = {
        # Go
        gopls.enable = true;

        # Haskell
        hls.enable = true;

        # JSON
        jsonls.enable = true;

        # Nix
        nil-ls = {
          enable = true;
          settings = {
            formatting.command = ["alejandra"];
          };
        };

        # Python
        pylsp.enable = true;

        # Rust
        rust-analyzer = {
          enable = true;
          installRustc = false;
          installCargo = false;
        };

        # Terraform
        terraformls.enable = true;

        # TypeScript
        ts-ls.enable = true;
      };
    };

    plugins.lspsaga = {
      enable = true;

      # Don't show action icon in signcolumn
      lightbulb.sign = false;

      # Turn off breadcrumbs
      symbolInWinbar.enable = false;
    };

    keymaps =
      [
        {
          key = "K";
          mode = ["n"];
          options.silent = true;
          action = ":Lspsaga hover_doc<CR>";
        }
        {
          key = "gd";
          mode = ["n"];
          options.silent = true;
          action = ":Lspsaga peek_definition<CR>";
        }
      ]
      ++ mkLeaderMappings "l" {
        "r" = ":Lspsaga rename<CR>";
        "o" = ":Lspsaga outline<CR>";
        "f" = ":Lspsaga finder<CR>";
        "a" = ":Lspsaga code_action<CR>";
        "d" = ":Lspsaga show_buf_diagnostics<CR>";
        "D" = ":Lspsaga show_workspace_diagnostics<CR>";
      };
  };
}
