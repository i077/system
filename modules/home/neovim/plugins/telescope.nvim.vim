lua << EOF
require('telescope').setup {}
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fF <cmd>Telescope git_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope commands<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>

nnoremap <leader>fd <cmd>Telescope diagnostics<cr>

nnoremap <C-p> <cmd>Telescope find_files<cr>

com Colors <cmd>Telescope colorscheme<cr>
