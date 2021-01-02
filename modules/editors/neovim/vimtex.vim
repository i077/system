" Disable LaTeXBox in favor of vimtex
let g:polyglot_disabled = ['tex', 'latex']

let g:vimtex_enabled = 1
" vimtex neovim remote support
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'
" Enable folding
let g:vimtex_fold_enabled = 1

" Configure vimtex
let g:vimtex_view_method = 'zathura'
set conceallevel=1
let g:tex_conceal = 'abdmg'
let g:vimtex_compiler_enabled = 1
