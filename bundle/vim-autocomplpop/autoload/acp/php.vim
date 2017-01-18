" Default 'meets' function for Php
function acp#php#Meets(context, ...)
  return g:acp_php_omni_length >= 0 &&
        \ a:context =~ '\w\(->\|::\)\k\{' . g:acp_php_omni_length . ',}$'
endfunction
