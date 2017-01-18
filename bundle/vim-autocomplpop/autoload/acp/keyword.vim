" Default 'meets' function for keywords
function acp#keyword#Meets(context, ...)
  if g:acp_keyword_length < 0
    return 0
  endif
  let match = matchstr(a:context, '\k\{' . g:acp_keyword_length . ',}$')
  if len(match) == 0
    return 0
  endif
  for ignored in g:acp_keyword_ignored
    " Do not attempt a completion
    " if the start of a match occurs in 'ignored'
    if stridx(ignored, match) == 0
      return 0
    endif
  endfor
  return 1
endfunction
