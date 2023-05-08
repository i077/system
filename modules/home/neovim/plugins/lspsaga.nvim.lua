local saga = require("lspsaga")
local keymap = vim.keymap.set

saga.init_lsp_saga()
-- Code actions
keymap({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- Rename
keymap("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { silent = true })
-- Peek definition
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Hoverdoc
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
