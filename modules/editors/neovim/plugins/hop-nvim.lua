local hop = require 'hop'
local map = vim.api.nvim_set_keymap
local mapopts = {noremap = true, silent = true}

map('n', 's', ':HopChar2<CR>', mapopts)
map('', '<Leader><Leader>w', ':HopWord<CR>', mapopts)
map('', '<Leader><Leader>j', ':HopLine<CR>', mapopts)
map('', '<Leader><Leader>k', ':HopLine<CR>', mapopts)
map('', '<Leader><Leader>f', ':HopChar1<CR>', mapopts)
map('', '<Leader><Leader>/', ':HopPattern<CR>', mapopts)
