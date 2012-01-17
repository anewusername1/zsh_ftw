" zsh_ftw.vim
" vim:set ft=vim et tw=78 sw=2:

if $ZSH == '' && expand('<sfile>') =~# '/.zsh_ftw/vim/plugin/zsh_ftw\.vim$'
  let $ZSH = expand('<sfile>')[0 : -38]
endif
if $ZSH == '' && filereadable(expand('~/.bashrc'))
  let $ZSH = expand(matchstr("\n".join(readfile(expand('~/.bashrc')),"\n")."\n",'\n\%(export\)\=\s*ZSH="\=\zs.\{-\}\ze"\=\n'))
endif
if $ZSH == ''
  let $ZSH = substitute(system("bash -i -c 'echo \"$ZSH\"'"),'\n$','','')
endif
if $ZSH == ''
  let $ZSH = expand('~/.zsh_ftw')
endif

function! s:HComplete(A,L,P)
  let match = split(glob($ZSH.'/'.a:A.'*'),"\n")
  return map(match,'v:val[strlen($ZSH)+1 : -1]')
endfunction
command! -bar -nargs=1 Hcommand :command! -bar -bang -nargs=1 -complete=customlist,s:HComplete H<args> :<args><lt>bang> $ZSH/<lt>args>

Hcommand cd
Hcommand lcd
Hcommand read
Hcommand edit
Hcommand split
Hcommand saveas
Hcommand tabedit

command! -bar -nargs=* -complete=dir Terrarails :execute 'Rails --template='.system("ruby -rubygems -e 'print Gem.bin_path(%(terraformation))'") . ' ' . <q-args>

command! -bar -range=% Trim :<line1>,<line2>s/\s\+$//e
command! -bar -range=% NotRocket :<line1>,<line2>s/:\(\w\+\)\s*=>/\1:/ge

command! -bar -nargs=* -bang -complete=file Rename :
      \ let v:errmsg = ""|
      \ saveas<bang> <args>|
      \ if v:errmsg == ""|
      \   call delete(expand("#"))|
      \ endif

command! -bar -nargs=0 -bang -complete=file Remove :
      \ let v:errmsg = ''|
      \ let s:removable = expand('%:p')|
      \ bdelete<bang>|
      \ if v:errmsg == ''|
      \   call delete(s:removable)|
      \ endif|
      \ unlet s:removable

function! HTry(function, ...)
  if exists('*'.a:function)
    return call(a:function, a:000)
  else
    return ''
  endif
endfunction

let g:is_bash = 1 " Highlight all .sh files as if they were bash
let g:ruby_minlines = 500
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDShutUp = 1
let g:VCSCommandDisableMappings = 1

let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr(':')} = ":\r"
let g:surround_indent = 1


if !exists('g:w_sleep')
  let g:w_sleep = 0
endif

function! s:Wall() abort
  let sleep = g:w_sleep ? 'sleep '.g:w_sleep.'m' : ''
  let tab = tabpagenr()
  let win = winnr()
  let seen = {}
  if !&readonly && expand('%') !=# ''
    let seen[bufnr('')] = 1
    write
  endif
  tabdo windo if !&readonly && expand('%') !=# '' && !has_key(seen, bufnr('')) | exe sleep | silent write | let seen[bufnr('')] = 1 | endif
  execute 'tabnext '.tab
  execute win.'wincmd w'
endfunction

command! -bar W              :call s:Wall()

command! -bar -nargs=0 SudoW :setl nomod|silent exe 'write !sudo tee % >/dev/null'|let &mod = v:shell_error

runtime! plugin/matchit.vim
runtime! macros/matchit.vim

map Y       y$
nnoremap <silent> <C-L> :nohls<CR><C-L>
inoremap <C-C> <Esc>`^

cnoremap          <C-O> <Up>
inoremap              ø <C-O>o
inoremap          <M-o> <C-O>o
" Emacs style mappings
inoremap          <C-A> <C-O>^
inoremap     <C-X><C-@> <C-A>
cnoremap          <C-A> <Home>
cnoremap     <C-X><C-A> <C-A>
" If at end of a line of spaces, delete back to the previous line.
" Otherwise, <Left>
inoremap <silent> <C-B> <C-R>=getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"<CR>
cnoremap          <C-B> <Left>
" If at end of line, decrease indent, else <Del>
inoremap <silent> <C-D> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"<CR>
cnoremap          <C-D> <Del>
" If at end of line, fix indent, else <Right>
inoremap <silent> <C-F> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"<CR>
inoremap          <C-E> <End>
cnoremap          <C-F> <Right>

noremap           <F1>   <Esc>
noremap!          <F1>   <Esc>

" NERDTree stuff
noremap <Leader>tr :NERDTree<return>
inoremap <Leader>tr :NERDTree<return>

" Enable TAB indent and SHIFT-TAB unindent
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv

" Open the OSX color picker and insert the hex value of the choosen color.
" Depends on: https://github.com/jnordberg/color-pick
inoremap <C-X>c #<C-R>=system('colorpick')<CR>

iabbrev Lidsa     Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
iabbrev rdebug    require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/\\\@<!|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

if !exists('g:syntax_on')
  syntax on
endif
filetype plugin indent on

augroup zsh_ftw
  autocmd!

  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
        \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

  autocmd BufNewFile,BufRead *.haml             set ft=haml
  autocmd BufNewFile,BufRead *.feature,*.story  set ft=cucumber
  autocmd BufRead * if ! did_filetype() && getline(1)." ".getline(2).
        \ " ".getline(3) =~? '<\%(!DOCTYPE \)\=html\>' | setf html | endif

  autocmd FileType javascript,coffee      setlocal et sw=2 sts=2 isk+=$
  autocmd FileType html,xhtml,css,scss    setlocal et sw=2 sts=2
  autocmd FileType eruby,yaml,ruby        setlocal et sw=2 sts=2
  autocmd FileType cucumber               setlocal et sw=2 sts=2
  autocmd FileType gitcommit              setlocal spell
  autocmd FileType gitconfig              setlocal noet sw=8
  autocmd FileType ruby                   setlocal comments=:#\  tw=79
  autocmd FileType sh,csh,zsh             setlocal et sw=2 sts=2
  autocmd FileType vim                    setlocal et sw=2 sts=2 keywordprg=:help

  autocmd Syntax   css  syn sync minlines=50

  autocmd FileType ruby nmap <buffer> <leader>bt <Plug>BlockToggle

  autocmd User Rails nnoremap <buffer> <D-r> :<C-U>Rake<CR>
  autocmd User Rails nnoremap <buffer> <D-R> :<C-U>.Rake<CR>
  autocmd User Rails Rnavcommand decorator app/decorators -suffix=_decorator.rb -default=model()
  autocmd User Rails Rnavcommand uploader app/uploaders -suffix=_uploader.rb -default=model()
  autocmd User Rails Rnavcommand steps features/step_definitions -suffix=_steps.rb -default=web
  autocmd User Rails Rnavcommand blueprint spec/blueprints -suffix=_blueprint.rb -default=model()
  autocmd User Rails Rnavcommand factory spec/factories -suffix=_factory.rb -default=model()
  autocmd User Rails Rnavcommand fabricator spec/fabricators -suffix=_fabricator.rb -default=model()
  autocmd User Rails Rnavcommand feature features -suffix=.feature -default=cucumber
  autocmd User Rails Rnavcommand support spec/support features/support -default=env
  autocmd User Rails Rnavcommand worker app/workers -suffix=_worker.rb -default=model()
  autocmd User Fugitive command! -bang -bar -buffer -nargs=* Gpr :Git<bang> pull --rebase <args>
augroup END

