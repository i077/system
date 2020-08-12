"" Deoplete
let g:deoplete#enable_at_startup = 1

"" LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'python': ['/run/current-system/sw/bin/pyls'],
    \ 'tex': ['/etc/profiles/per-user/imran/bin/texlab'],
    \ }
"" Don't nag me on every little hint
let g:LanguageClient_diagnosticsMaxSeverity = "Warning"
"" Disable virtual text
let g:LanguageClient_useVirtualText = "No"

"" ALE
"" Disable for languages that LanguageClient covers
"" (offers superior functionality)
let g:ale_linters = {
    \ 'python': [],
    \ 'tex': [],
    \ }

"" Vimtex
let g:vimtex_enabled = 1
" vimtex neovim remote support
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'

" Disable LaTeXBox in favor of vimtex
let g:polyglot_disabled = ['tex', 'latex']

" Configure vimtex
let g:vimtex_view_method = 'zathura'
set conceallevel=1
let g:tex_conceal = 'abdmg'
let g:vimtex_compiler_enabled = 1

" Use tmux with slime
let g:slime_target = "tmux"
