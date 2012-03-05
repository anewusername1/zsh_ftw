" set_tab_spaces.vim
" vim:set ft=vim et tw=78 sw=2:

function! SetTabSpaces()
  set tabstop=2
  set shiftwidth=2
  set smarttab
  set expandtab
endfunction

command! SetTabsAsSpaces call SetTabSpaces()
