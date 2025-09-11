" ------------------------------------------------------------
" general vim key mappings
" ------------------------------------------------------------
let mapleader=","
" show buffers
nmap        <C-B>     :buffers<CR>

" open a terminal
" nmap  <C-T>  :FloatermNew<CR>

" move through split windows
nmap <C-Up> :wincmd k<CR>
nmap <C-Down> :wincmd j<CR>
nmap <C-Left> :wincmd h<CR>
nmap <C-Right> :wincmd l<CR>

" ctrlfs
nnoremap <leader>W :CtrlSF

" toggle nerdtree
nmap <F5> :NERDTreeToggle<CR>

" Press F5 for black to format the code
" map <F5> :Black<CR>

" ------------------------------------------------------------
" vim-repl configuration
" ------------------------------------------------------------
" Press F7 to use flake8 on current python file
" f10
" autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBS<Cr>
" note: will not work if F11 is a special key in your application
" autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBN<Cr>
" autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>

" floaterm
" nnoremap   <silent>   <F7>    :FloatermNew<CR>
" tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
" nnoremap   <silent>   <F8>    :FloatermPrev<CR>
" tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
" nnoremap   <silent>   <F9>    :FloatermNext<CR>
" tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
" nnoremap   <silent>   <F12>   :FloatermToggle<CR>
" tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>

" floaterm
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
