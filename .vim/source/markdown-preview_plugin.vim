" md filetype configuration
augroup markdown_ft
  au!
  autocmd BufNewFile,BufRead *.md  MarkdownPreview
augroup END

" specify browser to open preview page

function! IsWSL()
  let uname = substitute(system('uname'),'\n','','')
  if uname == 'Linux'
    let lines = readfile("/proc/version")
    if lines[0] =~ "Microsoft"
        return 1
    endif
  endif
endfunction

if IsWSL()
  " WSL-specific settings
  let g:mkdp_browser = 'chrome.exe'
else
  " Native Linux settings
  let g:mkdp_browser = 'google-chrome-stable'
endif
