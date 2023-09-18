{...}: {
  programs.nixvim = {
    extraConfigLuaPre = ''
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
    '';

    plugins.nvim-cmp = {
      enable = true;

      sources = [
        [{name = "nvim_lsp";} {name = "path";}]
        [{name = "buffer";}]
      ];

      mappingPresets = ["insert" "cmdline"];
      mapping = {
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = false })"; # Accept only explicitly selected items
        "<Tab>" = ''
          function(fallback)
            if not cmp.select_next_item() then
              if vim.bo.buftype ~= "prompt" and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end
        '';
        "<S-Tab>" = ''
          function(fallback)
            if not cmp.select_prev_item() then
              if vim.bo.buftype ~= "prompt" and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end
        '';
      };
    };

    # Include other sources not in main setup table & setup other filetypes
    plugins.cmp-git.enable = true;
    plugins.cmp-cmdline.enable = true;

    extraConfigLua = ''
      local cmp = require('cmp')
      -- Set up git commit completions
      cmp.setup.filetype("gitcommit", {
          sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" }, { name = "path" } }),
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
