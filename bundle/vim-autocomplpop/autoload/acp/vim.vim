" Default 'meets' function for VimScript
function acp#vim#Meets(context, ...)
  return g:acp_vimscript_length >= 0 &&
        \ a:context =~ '\k\{' . g:acp_vimscript_length . ',}$'
endfunction
