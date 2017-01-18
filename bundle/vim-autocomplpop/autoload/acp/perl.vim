" Default 'meets' function for Perl
function acp#perl#Meets(context, ...)
  return has('perl') && g:acp_perl_omni_length >= 0 &&
        \ a:context =~ '\w->\k\{' . g:acp_perl_omni_length . ',}$'
endfunction
