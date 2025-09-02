source ~/.vim/source/general.vim

" ------------------------------------------------------------
" Load plugins
" ------------------------------------------------------------
" do NOT run all the below if using vimdiff
if !(&diff)
    source ~/.vim/source/plugins.vim
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
    source ~/.vim/source/vim-airline_plugin.vim
    source ~/.vim/source/flake8_plugin.vim
    source ~/.vim/source/vim-floaterm_plugin.vim
    source ~/.vim/source/markdown-preview_plugin.vim
    source ~/.vim/source/vimwiki_plugin.vim

    source ~/.vim/source/misc.vim
    source ~/.vim/source/visual.vim
endif
