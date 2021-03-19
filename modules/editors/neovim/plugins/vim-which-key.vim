let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

call which_key#register('<Space>', "g:which_key_map")

" Override the start of chords
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  '\'<CR>

" More detailed descriptions of chord groups
let g:which_key_map = {}

let g:which_key_map.g = { 
            \ 'name': '+git',
            \ 'c': 'commit',
            \ 'C': 'commit this file',
            \ 'l': 'log',
            \ 'L': 'log graph',
            \ 's': 'status',
            \ }
let g:which_key_map.s = { 'name': '+syntax' }
