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

" Use tmux with slime
let g:slime_target = "tmux"
