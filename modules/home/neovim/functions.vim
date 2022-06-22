" This section defines helpful functions and their respective commands,
" as well as autocmds for certain filetypes.

" Open a diff split containing changes to the file in the current buffer
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Use the 'z' command in fish to jump to a directory
function s:Z(str)
    let dir = system(['fish', '-c', 'z -e ' . a:str])
    echo "" . dir
    execute 'cd ' . dir
endfunction
com! -nargs=1 Z call s:Z("<args>")
