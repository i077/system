" This section sets mappings for neovim. Only includes built-in functionality.
" See plugins/ for plugin-specific mappings

" Leader is <Space>
let mapleader=" "
nnoremap <SPACE> <NOP>

" Go to last buffer
map <leader><Tab> <C-^>

" Work with OS clipboard
nnoremap gy "+y
nnoremap gp "+p
nnoremap gP "+P
vnoremap gy "+y
vnoremap gp "+p
vnoremap gP "+P

" :write with ZW
nmap ZW :w<CR>

" <Tab> thru popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Quickcorrect spelling errors in insert with <C-l>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
