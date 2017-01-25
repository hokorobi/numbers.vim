" Default 'meets' function for Css
function acp#css#Meets(context, ...)
  if a:0 > 0
    return a:context =~ '[:@!]$'
  endif
  if g:acp_css_omni_property_length >= 0 &&
        \ a:context =~ '\(^\|[;{]\)\s*\k\{' . g:acp_css_omni_property_length . ',}$'
    return 1
  endif
  if g:acp_css_omni_value_length >= 0 &&
        \ a:context =~ '[:@!]\s*\k\{' . g:acp_css_omni_value_length . ',}$'
    return 1
  endif
  return 0
endfunction
