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
  autocmd BufNewFile,BufRead *.sls set syntax=yaml
augroup END
" uml filetype configuration
augroup uml_ft
  au!
  autocmd BufNewFile,BufRead *.pu,*.uml,*.plantuml,*.puml,*.iuml PlantumlOpen
augroup END

" yaml filetype configuration
augroup yaml_ft
  au!
  autocmd BufNewFile,BufRead *.yml,*.yaml set filetype=yaml.ansible
  autocmd Filetype yaml.ansible AnyFoldActivate
augroup END

" Press F6 to toggle syntax highlighting on/off, and show current value.
:map <F6> :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax enable <Bar> endif <CR>

" recognize anything in my .Postponed directory as a news article, and anything
" at all with a .txt extension as being human-language text [this clobbers the
" `help' filetype, but that doesn't seem to prevent help from working
" properly]:
augroup filetype
  autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END

autocmd FileType mail set formatoptions+=t textwidth=72 " enable wrapping in mail
autocmd FileType human set formatoptions-=t textwidth=0 " disable wrapping in txt

" fixed indentation should be OK for XML and CSS
" Indentation set to 2.
autocmd FileType html,xhtml,css,xml,xslt set shiftwidth=2 softtabstop=2

" two space indentation for some files
autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2

" add completion for xHTML
autocmd FileType xhtml,html set omnifunc=htmlcomplete#CompleteTags

" add completion for XML
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
