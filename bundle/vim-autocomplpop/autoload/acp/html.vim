" Default 'meets' function for Html
function acp#html#Meets(context, ...)
  return g:acp_html_omni_length >= 0 &&
        \ a:context =~ '<\(\/\=\|[^>]\+ \)\k\{' . g:acp_html_omni_length . ',}$'
endfunction
