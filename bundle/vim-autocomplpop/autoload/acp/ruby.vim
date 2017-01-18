" Default 'meets' function for Ruby
function acp#ruby#Meets(context, ...)
  return has('ruby') &&
        \ ((g:acp_ruby_omni_method_length >= 0 && a:context =~ '\k\(\.\|::\)\k\{' . g:acp_ruby_omni_method_length . ',}$') ||
        \ (g:acp_ruby_omni_symbol_length >= 0 && a:context =~ '\(^\|[^:]\):\k\{' . g:acp_ruby_omni_symbol_length . ',}$'))
endfunction
