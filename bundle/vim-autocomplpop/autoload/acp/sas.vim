" Default 'meets' function for SAS
function acp#sas#Meets(context, ...)
  return g:acp_sas_omni_length >= 0 &&
        \ a:context =~ '\<proc\s\+\k\{' . g:acp_sas_omni_length . ',}$'
endfunction
