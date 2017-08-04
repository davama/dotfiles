runtime! archlinux.vim
set nu
set nocompatible        " Use Vim defaults (much better!)

" similar way you would work in a WIN enviroment
"source $VIMRUNTIME/mswin.vim

" Set color on
syntax on

" With a map leader it's possible to do extra key combinations
" " like <leader>w saves the current file
"let mapleader = ","
"let g:mapleader = ","

" Pressing ,ss will toggle and untoggle spell checking
"map <leader>ss :setlocal spell!<cr>
map ,ss :setlocal spell!

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

set ai "Auto indent
set si "Smart indent
"set wrap "Wrap lines

" Always show the status line
"set laststatus=2

" set F2 as write and quit when in COMMAND mode
map <F2> :wq!<cr>

" set F3 as quit without saving when in COMMAND mode
map <F3> :q!<cr>
" set F4 as write without quitting when in COMMAND mode
map <F4> :w!<cr>
" Press F5 to toggle highlighting on/off, and show current value.
:noremap <F5> :set hlsearch! hlsearch?<CR>

" Enable mouse support in console
set mouse=a

set clipboard+=unnamed
" Enable copy using Ctrl-Shift-c
map <C-c> "+y<cr>
" Enable paste using Ctrl-Shift-v
map <C-v> "+p<cr>

" Enable folding
autocmd FileType haskell setlocal foldmethod=marker " haskell
set foldmethod=indent " everyone else


"If you use Vim commands to paste text, nothing unexpected occurs. 
"The problem only arises when pasting from another application, 
"and only when you are not using a GUI version of Vim.
"Here's a little trick that uses terminal's bracketed paste mode to automatically set/unset Vim's paste mode when you paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" create a fold by placing cursor on char and type "zfa{" assuming "}" is the
" end of fold
" space to unfold and "za" to fold
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview
