" testing
set mousemodel=extend
" end testing

let g:syntastic_python_python_exec = 'python3'
" Ignore case when searching
set ignorecase
" set F2 as write and quit when in COMMAND mode
map <F2> :wqa!<CR>
" set F3 as quit without saving when in COMMAND mode
map <F3> :qa!<CR>
" set F4 as write without quitting when in COMMAND mode
map <F4> :w!<CR>
" Press F6 to toggle syntax highlighting on/off, and show current value.
:map <F6> :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax enable <Bar> endif <CR>


" ------------------------------------------------------------
" Load plugins
" ------------------------------------------------------------
" do NOT run all the below if using vimdiff
if !(&diff)
    source ~/.vim/source/plugins.vim
    source ~/.vim/source/general.vim
    source ~/.vim/source/keymaps.vim

    source ~/.vim/source/vim-indent-guides_plugin.vim
    source ~/.vim/source/vim-polyglot_plugin.vim
    source ~/.vim/source/vim-move_plugin.vim
    source ~/.vim/source/auto-pairs_plugin.vim
    source ~/.vim/source/nerdtree_plugin.vim
    source ~/.vim/source/vim-fswitch_plugin.vim
    source ~/.vim/source/ctrlsf_plugin.vim
    source ~/.vim/source/ctrlsf_plugin.vim
    source ~/.vim/source/YouCompleteMe_plugin.vim
    source ~/.vim/source/tagbar_plugin.vim
    source ~/.vim/source/lightline_plugin.vim
    source ~/.vim/source/flake8_plugin.vim
    source ~/.vim/source/vim-floaterm_plugin.vim

    source ~/.vim/source/misc.vim
    source ~/.vim/source/visual.vim
endif
