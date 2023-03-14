" This section sets the UI/look and feel of neovim.

" Colorscheme
set background=dark
set termguicolors
let ayucolor="dark"
let g:oceanic_next_terminal_bold=1
let g:oceanic_next_terminal_italic=1
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_italic=1
let g:gruvbox_italicize_comments=1

" Remove background from conceal chars
hi Conceal guibg=None

" Neovide/other GUI stuff
if exists('g:neovide') || exists('g:started_by_firenvim')
    " Set guifont
    set guifont=Berkeley\ Mono:10
    let g:neovide_cursor_trail_size=0
endif
