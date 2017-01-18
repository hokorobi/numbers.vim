" Default 'meets' function for JavaScript
function acp#javascript#Meets(context, ...)
  return g:acp_javascript_omni_length >= 0 &&
        \ a:context =~ '\k\.\k\{' . g:acp_javascript_omni_length . ',}$'
endfunction
