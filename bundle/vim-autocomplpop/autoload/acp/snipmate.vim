" Default completion function for snipMate
function acp#snipmate#Complete(findstart, base)
  if a:findstart
    let pos = matchstrpos(strpart(getline('.'), 0, col('.') - 1), '\S\+$')[1]
    return pos >= 0 ? pos : -3
  endif
  let base = type(a:base) == v:t_number ? string(a:base) : a:base
  let items = filter(GetSnipsInCurrentScope(),
        \ 'strpart(v:key, 0, len(base)) ==? base')
  return map(sort(items(items)), 's:MakeSnipmateItems(v:val[0], v:val[1])')
endfunction

" Default 'meets' function for snipMate
function acp#snipmate#Meets(context, ...)
  if g:acp_snipmate_length < 0
    return 0
  endif
  let match = matchstr(a:context, '\S\{' . g:acp_snipmate_length . ',}$')
  if len(match) == 0
    return 0
  endif
  let key = match
  if !exists('s:snip_items')
    let s:snip_items = {}
  endif
  if !has_key(s:snip_items, key)
    let s:snip_items[key] = items(GetSnipsInCurrentScope())
    call filter(s:snip_items[key], 'strpart(v:val[0], 0, len(match)) ==? match')
  endif
  return !empty('s:snip_items[key]')
endfunction

" Default close function for snipMate
function acp#snipmate#Close()
  let trigger = matchstr(strpart(getline('.'), 0, col('.') - 1), '\S\+$')
  for key in keys(GetSnipsInCurrentScope())
    if trigger ==# key
      call feedkeys("\<C-r>=TriggerSnippet()\<CR>", 'n')
      return 1
    endif
  endfor
  return 0
endfunction

" Create snipMate item list for the complete function
function s:MakeSnipmateItems(key, val)
  return {
        \ 'word': a:key,
        \ 'menu': strpart((type(a:val) == v:t_list ?
        \         '[' . len(a:val) . '] ' . join(map(copy(a:val), 'v:val[0]'), ', ') :
        \         substitute(a:val, '\(\n\|\s\)\+', ' ', 'g')
        \         ), 0, 80),
        \ }
endfunction
