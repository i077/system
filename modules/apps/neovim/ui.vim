" This section sets the UI/look and feel of neovim.

" Colorscheme
set background=dark
colorscheme gruvbox
let ayucolor="dark"
let g:gruvbox_contrast_dark="hard"
set termguicolors
let g:oceanic_next_terminal_bold=1
let g:oceanic_next_terminal_italic=1

" Remove background from conceal chars
hi Conceal guibg=None

"" Airline config
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Smarter tabline
let g:airline#extensions#tabline#enabled = 1

"" FZF
" Set layout to a floating window
let g:fzf_layout = {
            \ 'window': { 'width': 0.9, 'height': 0.6 }
            \ }
