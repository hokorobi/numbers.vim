" Default 'meets' function for file names
function acp#file#Meets(context, ...)
  if g:acp_file_length < 0
    return 0
  endif
  let sep = (has('win32') || has('win64')) ? '[/\\]' : '\/'
  if a:0 > 0 ?
        \ a:context !~ '\f' . sep . '\f\{' . a:1 . '}$' :
        \ a:context !~ '\f' . sep . '\f\{' . g:acp_file_length . ',}$'
    return 0
  endif
  return a:context !~ '[*/\\][/\\]\f*$\|[^[:print:]]\f*$'
endfunction
