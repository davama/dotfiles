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
  " open-browser - Open URI with your favorite browser
  Plugin 'tyru/open-browser.vim'
  " plantuml-previewer
  Plugin 'weirongxu/plantuml-previewer.vim'
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
  " vim-airline/vim-airline - Lean & mean status/tabline
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
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
  " markdown-preview - preview markdown in browser
  " other requirements - https://github.com/iamcco/markdown-preview.nvim/issues/637#issuecomment-2266213843A
  Plugin 'iamcco/markdown-preview.nvim'
  " Dockerfile.vim - Vim syntax file for Docker's Dockerfile
  Plugin 'ekalinin/Dockerfile.vim'
  " wincent/terminus - enhance vim integration with the terminal
  Plugin 'wincent/terminus'
  " vimwiki/vimwiki - personal wiki for vim
  Plugin 'vimwiki/vimwiki'
  " patrickdavey/vimwiki_markdown - allow wiki pages to be written in markdown
  Plugin 'patrickdavey/vimwiki_markdown'
  " tpope/vim-commentary - comment stuff out
  Plugin 'tpope/vim-commentary'
  " tpope/vim-endwise - helps to end certain structures automatically
  Plugin 'tpope/vim-endwise'
  " pseewald/vim-anyfold - Generic folding mechanism and motion based on indentation
  Plugin 'pseewald/vim-anyfold'
  " machakann/vim-highlightedyank - Make the yanked region apparent
  Plugin 'machakann/vim-highlightedyank'
  " AndrewRadev/splitjoin.vim - switching between a single-line statement and a multi-line one
  Plugin 'AndrewRadev/splitjoin.vim'
  " romainl/vim-cool - disables search highlighting when you are done searching and re-enables it when you search again
  Plugin 'romainl/vim-cool'
  " dense-analysis/ale - ALE (Asynchronous Lint Engine) is a plugin providing linting (syntax checking and semantic errors) while you edit your text files, and acts as a Vim Language Server Protocol client.
  Plugin 'dense-analysis/ale'
  " pearofducks/ansible-vim - vim syntax plugin for Ansible 2.x
  Plugin 'pearofducks/ansible-vim'
  " tpope/vim-surround - mappings to easily delete, change and add such surroundings in pairs
  Plugin 'tpope/vim-surround'
  " github/copilot.vim - GitHub Copilot is an AI pair programmer tool that helps you write code faster and smarter
  Plugin 'github/copilot.vim'
call vundle#end()
