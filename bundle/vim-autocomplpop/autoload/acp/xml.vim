" Default 'meets' function for Xml
function acp#xml#Meets(context, ...)
  return g:acp_xml_omni_length >= 0 &&
        \ a:context =~ '<\(\/\=\|[^>]\+ \)\k\{' . g:acp_xml_omni_length . ',}$'
endfunction
