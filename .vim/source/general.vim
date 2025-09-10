" ------------------------------------------------------------
" basic vim configuration
" ------------------------------------------------------------
let g:syntastic_python_python_exec = 'python3'
" Ignore case when searching
set ignorecase

" enable open file to last cursor position
source $VIMRUNTIME/vimrc_example.vim
" not set newline at end of file
:set nofixeol
:set nofixendofline

" create tmp dir
call mkdir($HOME . "/.vim/tmp/backup", "p", 0700)
call mkdir($HOME . "/.vim/tmp/swap", "p", 0700)
call mkdir($HOME . "/.vim/tmp/undo", "p", 0700)

" change temp files creation locations
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
set undodir=~/.vim/tmp/undo//

set nocompatible
filetype off            " filetype detection
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

" set F2 as write and quit when in COMMAND mode
map <F2> :wqa!<CR>
" set F3 as quit without saving when in COMMAND mode
map <F3> :qa!<CR>
" set F4 as write without quitting when in COMMAND mode
map <F4> :w!<CR>
