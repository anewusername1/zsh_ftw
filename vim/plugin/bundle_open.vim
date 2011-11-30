" bundle_open.vim
" vim:set ft=vim et tw=78 sw=2:

" Bundle Open command, from Bernerd Schaefer
" Call with :BO <gemname>
function! s:BundleOpen(Gem) abort
  if exists(':Btabedit')
    execute 'Btabedit '.a:Gem
    redraw
    let v:warningmsg = 'Use :Btabedit instead. It has tab complete!'
    echomsg v:warningmsg
    return
  endif
  let path = system('bundle show '.a:Gem)
  if v:shell_error != 0
    echo 'failed to run command'
  else
    exe 'tabedit '.substitute(path, '\v\C\n$', '', '') | :lcd %
  endif
endfunction


" :BO capybara
:command! -nargs=1 BundleOpen :call s:BundleOpen(<q-args>)
