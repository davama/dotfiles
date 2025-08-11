" ------------------------------------------------------------
" tagbar configuration
" ------------------------------------------------------------
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_position = 'botright vertical'
autocmd FileType python TagbarOpen
nmap        <F9>      :TagbarToggle<CR>
