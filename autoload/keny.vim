if exists('g:loaded_keny')
  finish
endif
let g:loaded_keny = 1

let s:save_cpo = &cpo
set cpo&vim

function! keny#ToggleComments(leader, ...)
  if getline('.') !=# ''
    let l:leader = escape(a:leader, '\/*')
    let l:tail   = a:0 > 0 ? escape(a:1, '\/*') : ''
    " Add or remove commenting syntax depending on
    " whether there is commenting syntax at the beginning of a line
    if getline('.') =~ '^' . l:leader . '\(.*\)' . l:tail . '$'
      silent exec 's/^' . l:leader . '\(.*\)' . l:tail . '$/\1/'
    else
      silent exec 's/^\(.*\)$/' . l:leader . '\1' . l:tail . '/'
    endif
  endif
  " Move cursor to the beginning of the next line
  silent exec 'normal! +'
  return ''
endfunction

function! keny#SplitLineNicely()
  " Save previous value of last search register
  let l:saved_last_search_pattern = @/
  " :substitute replaces the content of the register with the
  " pattern highlighting all whitespaces in the file
  substitute /\s\+/\r/g
  " Restore previous search register
  let @/ = l:saved_last_search_pattern
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
