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
