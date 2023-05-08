local diaglist = require("diaglist")
diaglist.init({})

-- Add keybinds
vim.keymap.set("n", "<leader>dl", diaglist.open_all_diagnostics)
