" ------------------------------------------------------------
" flake8 configuration
" ------------------------------------------------------------
autocmd BufWritePost *.py call Flake8()
let g:flake8_quickfix_height=15
let g:flake8_show_in_file=1 " show marks in the file
let g:flake8_show_in_gutter=1
