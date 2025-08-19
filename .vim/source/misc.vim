" ------------------------------------------------------------
" misc
" ------------------------------------------------------------
" Display TAB charecters as Erros
match Error /\t/
" Highlight trailing whitespace
autocmd BufWinEnter <buffer> match Error /\s\+$/
autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
autocmd InsertLeave <buffer> match Error /\s\+$/
autocmd BufWinLeave <buffer> call clearmatches()
" sls filetype configuration
augroup sls_ft
  au!
  autocmd BufNewFile,BufRead *.sls   set syntax=yaml
augroup END
" uml filetype configuration
augroup uml_ft
  au!
  autocmd BufNewFile,BufRead *.pu,*.uml,*.plantuml,*.puml,*.iuml PlantumlOpen
augroup END
