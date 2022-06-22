" Set layout to a floating window
let g:fzf_layout = {
            \ 'window': { 'width': 0.9, 'height': 0.7 }
            \ }

" Dynamic :Rg with FZF
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
com! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Keybinds
noremap <silent> <leader>ff :Files<CR>
noremap <silent> <leader>fF :GitFiles<CR>
noremap <silent> <leader>fl :BLines<CR>
noremap <silent> <leader>fL :Lines<CR>
noremap <silent> <leader>fg :RG<CR>
noremap <silent> <leader>fw :Windows<CR>
noremap <silent> <leader>fb :Buffers<CR>
noremap <silent> <leader>fc :Commands<CR>
noremap <silent> <leader>fh :Helptags<CR>
noremap <silent> <leader>fr :History<CR>

" Ctrl-P-like keybinds
noremap <silent> <C-p> :Files<CR>
noremap <silent> <M-p> :BLines<CR>
noremap <silent> <M-c> :Commands<CR>
