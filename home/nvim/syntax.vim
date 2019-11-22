"" Deoplete
let g:deoplete#enable_at_startup = 1

"" LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'python': ['/home/imran/.nix-profile/bin/pyls'],
    \ }

"" Vimtex
let g:vimtex_enabled = 1
" vimtex neovim remote support
let g:vimtex_compiler_progname = 'nvr'

" Disable LaTeXBox in favor of vimtex
let g:polyglot_disabled = ['tex', 'latex']

" Configure vimtex
let g:vimtex_view_method = 'zathura'
set conceallevel=1
let g:tex_conceal = 'abdmg'
let g:vimtex_compiler_enabled = 1

" Use tmux with slime
let g:slime_target = "tmux"
