require("trouble").setup {icons = false}

-- Add keybindings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
               {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
               {silent = true, noremap = true})

-- Integrate with Telescope
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
telescope.setup {
  defaults = {
    mappings = {
      i = {["<c-t>"] = trouble.open_with_trouble},
      n = {["<c-t>"] = trouble.open_with_trouble}
    }
  }
}
