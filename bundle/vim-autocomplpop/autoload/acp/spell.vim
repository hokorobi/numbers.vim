" Default 'meets' function for spelling completion
function acp#spell#Meets(context, ...)
  return &spell && g:acp_spell_length >= 0 &&
        \ a:context =~ '\w\{' . g:acp_spell_length . ',}$'
endfunction
