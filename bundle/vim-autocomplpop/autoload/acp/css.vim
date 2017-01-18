" Default 'meets' function for Css
function acp#css#Meets(context, ...)
  return (g:acp_css_omni_property_length >= 0 &&
        \ a:context =~ '\(^\|[;{]\)\s*\k\{' . g:acp_css_omni_property_length . ',}$') ||
        \ (g:acp_css_omni_value_length >= 0 &&
        \ a:context =~ '[:@!]\s*\k\{' . g:acp_css_omni_value_length . ',}$')
endfunction
