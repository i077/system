local saga = require 'lspsaga'

saga.init_lsp_saga{
  error_sign = "⨯",
  warn_sign = "⚠",
  hint_sign = ".",
  infor_sign = "i",
}

local mapopts = { noremap=true, silent=true }
local map = vim.api.nvim_set_keymap
map('n', 'K',          ':Lspsaga hover_doc<CR>',              mapopts)
map('n', '<C-K>',      ':Lspsaga signature_help<CR>',         mapopts)
map('n', 'gd',         ':Lspsaga preview_definition<CR>',     mapopts)
map('n', '[d',         ':Lspsaga diagnostic_jump_prev<CR>',   mapopts)
map('n', ']d',         ':Lspsaga diagnostic_jump_next<CR>',   mapopts)
map('n', '<leader>sh', ':Lspsaga lsp_finder<CR>',             mapopts)
map('n', '<leader>sr', ':Lspsaga rename<CR>',                 mapopts)
map('n', '<leader>sa', ':Lspsaga code_action<CR>',            mapopts)
map('v', '<leader>sa', ':<C-U>Lspsaga range_code_action<CR>', mapopts)

-- Scrolling in hover_doc
map('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", mapopts)
map('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", mapopts)
