let g:LanguageClient_serverCommands = {
    \ 'python': ['/run/current-system/sw/bin/pyls'],
    \ 'tex': ['/etc/profiles/per-user/imran/bin/texlab'],
    \ }
"" Don't nag me on every little hint
let g:LanguageClient_diagnosticsMaxSeverity = "Warning"
"" Disable virtual text
let g:LanguageClient_useVirtualText = "No"
