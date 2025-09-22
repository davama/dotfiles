set modifiable
" disable copilot on all files - enable with :Copilot enable
autocmd VimEnter * Copilot disable

let $NODE_TLS_REJECT_UNAUTHORIZED = "0"
let g:copilot_proxy_strict_ssl = v:false
let g:copilot_proxy = $inter_proxy
