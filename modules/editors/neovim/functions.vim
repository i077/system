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

" Dynamic :Rg with FZF
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
com! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" AUTOCMDS
" ------------

" Enable vimtex in *TeX files
autocmd filetype tex call vimtex#init()

" Use pandoc as dispatch job
autocmd filetype pandoc let b:dispatch = 'pandoc -o %:r.pdf %'
