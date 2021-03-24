autocmd BufEnter * lua require'completion'.on_attach()

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Restrict maximum completion height
set pumheight=16
set pumblend=15

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Completion strategies
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_menu_length = 20

" Complete on backspace
let g:completion_trigger_on_delete = 1

lua<<EOF
vim.g.completion_chain_complete_list = {
  default = {
    { complete_items = { 'lsp', 'ts', 'buffer' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
  python = {
    { complete_items = { 'lsp' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
  tex = {
    { complete_items = { 'lsp' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
}
EOF
