" Colorscheme
set background=dark
let ayucolor="dark"
let g:gruvbox_contrast_dark="soft"
colorscheme base16-default-dark
set termguicolors

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Enable mouse in terminal
set mouse=a

" Tabs are 4 spaces
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

" Fold indents
set foldmethod=indent

" Word wrapping
set wrap linebreak
