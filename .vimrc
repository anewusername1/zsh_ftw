runtime! autoload/pathogen.vim
if exists('g:loaded_pathogen')
  call pathogen#runtime_prepend_subdirectories(expand('~/.vimbundles'))
endif

syntax on
filetype plugin indent on

set visualbell
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set hlsearch

augroup vimrc
  autocmd!
  autocmd GuiEnter * set guifont=Monaco:h12 guioptions-=T columns=120 lines=70 number
augroup END

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction

function! SetTabSpaces()
  set tabstop=2
  set shiftwidth=2
  set expandtab
endfunction

command! PrettyXML call DoPrettyXML()
command! SetTabsAsSpaces call SetTabSpaces()

map <S-Enter> O<Esc>
map <CR> o<Esc>

nmap n nzz
nmap N Nzz
