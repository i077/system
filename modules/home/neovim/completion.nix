{...}: {
  programs.nixvim = {
    # Use icons insteead of text in completion menu when showing kind
    plugins.lspkind = {
      enable = true;
      preset = "codicons";
      mode = "symbol";
    };

    plugins.nvim-cmp = {
      enable = true;

      sources = [
        {name = "nvim_lsp"; groupIndex = 1;}
        {name = "path"; groupIndex = 1;}
        {name = "buffer"; groupIndex = 2;}
      ];

      view.entries = {
        name = "custom";
        selection_order = "near_cursor";
      };

      mappingPresets = ["insert" "cmdline"];
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = false })"; # Accept only explicitly selected items
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
        "<M-u>" = "cmp.mapping.scroll_docs(-4)";
        "<M-d>" = "cmp.mapping.scroll_docs(4)";
      };
    };

    # Include other sources not in main setup table & setup other filetypes
    plugins.cmp-git.enable = true;
    plugins.cmp-cmdline.enable = true;
    plugins.cmp-fish.enable = true;

    extraConfigLua = ''
      local cmp = require('cmp')
      -- Set up git commit completions
      cmp.setup.filetype("gitcommit", {
          sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" }, { name = "path" } }),
      })

      cmp.setup.filetype("fish", {
          sources = cmp.config.sources({ { name = "fish" } }, { { name = "buffer" }, { name = "path" } }),
      })

      -- Use buffer source for `/`
      cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    '';
  };
}
