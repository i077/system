" This section sets mappings for neovim. This includes built-in functionality
" as well as plugin functionality.

" BUILTINS
" ============

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

" PLUGINS
" ============

" Toggle NERDTree
map <silent> <leader>n :NERDTreeToggle<CR>

" Fugitive stuff
map <silent> <leader>gs :Gstatus<CR>
map <silent> <leader>gl :Glog<CR>
map <silent> <leader>gL :Git lga<CR>
map <silent> <leader>gc :Gcommit<CR>
map <silent> <leader>gC :Gcommit %<CR>

" Denite
" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction
" Files buffer
noremap <silent> <c-P> :Files<CR>
" Lines buffer
noremap <silent> <m-p> :Lines<CR>

" Run Dispatch job
nnoremap <silent> <leader>m :Dispatch!<CR>

" Easymotion
" Emulate vim-sneak
nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-F2)

" Emulate quickscope and relative numbers
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>l <Plug>(easymotion-lineforward)

" COC
" Remap keys for gotos
nmap <silent> <Leader>sd <Plug>(coc-definition)
nmap <silent> <Leader>sD <Plug>(coc-type-definition)
nmap <silent> <Leader>si <Plug>(coc-implementation)
nmap <silent> <Leader>sr <Plug>(coc-references)

" In markdown, align tables
au FileType markdown vmap <silent> <Leader><Bslash> :EasyAlign*<Bar><Enter>
