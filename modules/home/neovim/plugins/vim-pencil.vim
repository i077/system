if !exists('g:vscode')
    augroup pencil
        autocmd!
        autocmd FileType markdown,mkd call pencil#init()
    augroup END
endif

" Set text width to 100 cols
let g:pencil#textwidth = 100
