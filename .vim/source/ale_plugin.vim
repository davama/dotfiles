let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'yaml.ansible': ['ansible-lint', 'prettier'],
\   'sh': ['shfmt'],
\   'python': ['isort', 'black', 'add_blank_lines_for_python_control_statements'],
\   'json': ['jq'],
\}

let g:ale_linters = {
\   'yaml.ansible': ['ansible-lint'],
\   'python': ['flake8'],
\   'json': ['jq'],
\}

let g:airline#extensions#ale#enabled = 1 " Airline will handle the rest.

" message formatting
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format='%linter% %severity% (%code%): %s'
let g:ale_loclist_msg_format='%linter% %severity% (%code%): %s'


" auto-fix on save
let g:ale_fix_on_save = 1

" disable specific highlights
let g:ale_exclude_highlights = ['line too long', 'E501']
let g:ale_yaml_yamllint_options='-d "{extends: relaxed, rules: {line-length: disable}}"'

" disable code completion; already handled by YCM
let g:ale_completion_enabled = 0
