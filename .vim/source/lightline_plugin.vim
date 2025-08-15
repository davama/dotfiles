" remove status line that is no longer needed because of this plugin
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ],
      \   'left': [ [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename',
      \ }
      \ }

" get relative path for `filename` when working on a project
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let root = fnamemodify(get(b:, 'gitbranch_path'), ':h:h')

