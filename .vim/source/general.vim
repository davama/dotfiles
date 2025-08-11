 " ------------------------------------------------------------
 " basic vim configuration
 " ------------------------------------------------------------
 set nocompatible
 filetype off
 set nu                  " Enable line numbers
 syntax on               " Enable synax highlighting
 set incsearch           " Enable incremental search
 set hlsearch            " Enable highlight search
 set splitbelow          " Always split below"
 set mouse=a             " Enable mouse drag on window splits
 set tabstop=4           " How many columns of whitespace a \t is worth
 set shiftwidth=4        " How many columns of whitespace a “level of indentation” is worth
 set expandtab           " Use spaces when tabbing
 if !has('nvim')
     set termwinsize=15x0    " Set terminal size
 endif
 " set background=dark     " Set background
 " colorscheme scheakur    " Set color scheme
 let g:ycm_autoclose_preview_window_after_completion=1
