" Run Dispatch job
nnoremap <silent> <leader>m :Dispatch!<CR>

" Use pandoc as dispatch job for pandoc filess
autocmd filetype pandoc let b:dispatch = 'pandoc -o %:r.pdf %'
