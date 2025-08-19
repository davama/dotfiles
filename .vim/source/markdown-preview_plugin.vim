" md filetype configuration
augroup markdown_ft
  au!
  autocmd BufNewFile,BufRead *.md  MarkdownPreview
augroup END

" specify browser to open preview page
let g:mkdp_browser = 'chrome.exe'
