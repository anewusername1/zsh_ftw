let g:go_def_mapping_enabled = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

" pulled from https://github.com/fatih/vim-go/blob/master/ftplugin/go.vim
" Don't enable go_def_mapping_enabled because I want <c-t> to map to tagbar
nnoremap <buffer> <silent> gd :GoDef<cr>
nnoremap <C-]> :GoDef<cr>
