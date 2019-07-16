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

" Open the neovim config file
function! s:EditConfig()
    :vs ~/system/home/neovim.nix
endfunction
com! EditConfig call s:EditConfig()

" AUTOCMDS
" ------------

" Enable vimtex autocompiler in *TeX files
autocmd filetype tex call vimtex#compiler#compile()

" Use pandoc as dispatch job
autocmd filetype pandoc let b:dispatch = 'pandoc -o %:r.pdf %'
