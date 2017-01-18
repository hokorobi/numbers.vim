" Self-defined functions
function! keny#ToggleComments(leader, ...)
  let l:save_cpo   = &cpo
  let l:save_paste = &paste
  set cpo&vim
  set paste
  if getline('.') !=# ''
    let l:leader = escape(a:leader, '\/*')
    if a:0 > 0
      let l:tail = escape(a:1, '\/*')
    else
      let l:tail = ''
    end
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
  let &cpo   = l:save_cpo
  let &paste = l:save_paste
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
