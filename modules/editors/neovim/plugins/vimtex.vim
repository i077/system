let g:vimtex_enabled = 1
let g:tex_flavor = 'latex'

" vimtex neovim remote support
let g:vimtex_compiler_progname = 'nvr'

" Enable folding
let g:vimtex_fold_enabled = 1

" Enable vimtex in *TeX files
autocmd filetype tex call vimtex#init()

" Use zathura as viewer
let g:vimtex_view_method = 'zathura'

" Use conceal chars
set conceallevel=1
let g:tex_conceal = 'abdmg'

" Autocompile
let g:vimtex_compiler_enabled = 1
