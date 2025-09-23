set modifiable
" disable copilot on all files - enable with :Copilot enable
autocmd VimEnter * Copilot disable

let $NODE_TLS_REJECT_UNAUTHORIZED = "0"
let g:copilot_proxy_strict_ssl = v:false
let g:copilot_proxy = $inter_proxy

" custom global var for toggle function
let g:copilot_enabled = v:true

function! ToggleCopilot()
  if g:copilot_enabled
    Copilot disable
    let g:copilot_enabled = v:false
    " echo "Copilot disabled"
  else
    Copilot enable
    let g:copilot_enabled = v:true
    " echo "Copilot enabled"
  endif
  Copilot status
endfunction

nnoremap <leader>c :call ToggleCopilot()<CR>
