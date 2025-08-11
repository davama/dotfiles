" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" Plugins will be downloaded under the specified directory.
call vundle#begin('~/.vim/plugged')
  " Let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'
  " Colorschemes
  Plugin 'kristijanhusak/vim-hybrid-material'
  Plugin 'cocopon/iceberg.vim'
  Plugin 'arcticicestudio/nord-vim'
  Plugin 'sjl/badwolf'
  Plugin 'lifepillar/vim-solarized8'
  Plugin 'scheakur/vim-scheakur'
  Plugin 'Badacadabra/vim-archery'
  Plugin 'mhartington/oceanic-next'

  " PloyGlot - collection of language packs for Vim
  Plugin 'sheerun/vim-polyglot'
  " Auto Pairs - Insert or delete brackets, parens, quotes in pair.
  Plugin 'jiangmiao/auto-pairs'
  " NERDTree - file system explorer for the Vim
  Plugin 'preservim/nerdtree'
  " Tagbar - provides an easy way to browse the tags of the current file and get an overview of its structure
  Plugin 'preservim/tagbar'
  " ctrlsf.vim - An ack/ag/pt/rg powered code search and view tool
  Plugin 'dyng/ctrlsf.vim'
  " vim-fswitch - help switching between companion files
  Plugin 'derekwyatt/vim-fswitch'
  " YouCompleteMe - fast, as-you-type, fuzzy-search code completion, comprehension and refactoring engine
  Plugin 'ycm-core/YouCompleteMe'
  " vim-move - moves lines and selections in a more visual manner
  Plugin 'matze/vim-move'
  " planttuml-syntax - syntax file for plantuml
  Plugin 'aklt/plantuml-syntax'
  " vim-slumlord - gives you a 'live preview' of your UML diagrams when you save
  Plugin 'scrooloose/vim-slumlord'
  " indent guide - visually displaying indent levels
  Plugin 'nathanaelkane/vim-indent-guides'
  " fugitive - git wrapper
  Plugin 'tpope/vim-fugitive'
  " rhubarb - hub for git wrapper - vim-fugitive
  Plugin 'tpope/vim-rhubarb'
  " vim-repl - Open the interactive environment with the code you are writing
  Plugin 'sillybun/vim-repl'
  " flake8 - runs the currently open file through Flake8, a static syntax and style checker for Python source code
  Plugin 'nvie/vim-flake8'
  " black - uncompromising Python code formatter
  Plugin 'psf/black'
  " lightline - A light and configurable statusline/tabline
  Plugin 'itchyny/lightline.vim'
  " vim-gitbranch - provides a function which returns the name of the git branch - used in lightline.vim
  Plugin 'itchyny/vim-gitbranch'
  " vim-floaterm - Use (neo)vim terminal in the floating/popup window
  Plugin 'voldikss/vim-floaterm'
  " vim-visual-multi
  Plugin 'mg979/vim-visual-multi'
  " vim-eunuch - run UNIX shell commands that need it the most
  Plugin 'tpope/vim-eunuch'
  " vim-gitgutter - shows a git diff in the sign column
  Plugin 'airblade/vim-gitgutter'
call vundle#end()
