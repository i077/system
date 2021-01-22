" keep cursor column on easymotion-{j,k}
let g:EasyMotion_startofline = 0

" Emulate vim-sneak
nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-F2)

" Emulate quickscope and relative numbers
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>l <Plug>(easymotion-lineforward)
