" This section sets options specific to the editing UI in neovim.

" Highlight the current line
set cursorline

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Enable mouse in terminal
if has('mouse')
    set mouse=a
endif

" Tabs are visually 4 spaces
set tabstop=4
" Tabs are literally 4 spaces
set softtabstop=4
" TAB inserts spaces
set expandtab
set shiftwidth=4

" Fold indents
set foldmethod=indent

" Word wrapping
set wrap linebreak

" Show results of :substitute
set inccommand=nosplit

" Do case insentitive search unless capital letter present
set smartcase

" Compatibility with COC
" set shell=/bin/sh

" Easymotion
let g:EasyMotion_startofline = 0 " keep cursor column on easymotion-{j,k}

" Pencil
let g:pencil#textwidth = 100
let g:pencil#wrapModeDefault = 'hard'
" Auto-init pencil for markdown files
" Workaround to set textwidth from https://github.com/reedes/vim-pencil/issues/85
augroup pencil
    autocmd!
    autocmd FileType markdown,pandoc,mkd
                \ call pencil#init() | setlocal textwidth=100
augroup END
" Suspend formatting when prefixing command with K
let g:pencil#map#suspend_af = 'K'
