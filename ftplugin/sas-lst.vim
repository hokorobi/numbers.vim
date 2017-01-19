" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Key mappings
nnoremap <buffer> <silent> <F2> :call <SID>SwitchSASBuffer('sas', 1)<CR>
vnoremap <buffer> <silent> <F2> :<C-u>call <SID>SwitchSASBuffer('sas', 1)<CR>
inoremap <buffer> <silent> <F2> <Esc>:call <SID>SwitchSASBuffer('sas', 1)<CR>

nnoremap <buffer> <silent> <F3> :call <SID>SwitchSASBuffer('log', 0)<CR>
vnoremap <buffer> <silent> <F3> :<C-u>call <SID>SwitchSASBuffer('log', 0)<CR>
inoremap <buffer> <silent> <F3> <Esc>:call <SID>SwitchSASBuffer('log', 0)<CR>

nnoremap <buffer> <silent> <F4> :call <SID>SwitchSASBuffer('lst', 0)<CR>
vnoremap <buffer> <silent> <F4> :<C-u>call <SID>SwitchSASBuffer('lst', 0)<CR>
inoremap <buffer> <silent> <F4> <Esc>:call <SID>SwitchSASBuffer('lst', 0)<CR>

" Local functions
function! s:SwitchSASBuffer(dest, readwrite)
  if expand('%:e') ==# a:dest | return | endif
  let to_buffer = substitute(bufname('%'), expand('%:e') . '$', a:dest, '')
  if bufnr(to_buffer) >= 0
    silent execute 'buffer' bufnr(to_buffer)
  elseif filereadable(expand('%<') . '.' . a:dest)
    silent execute (a:readwrite ? 'edit' : 'view') fnameescape(expand('%<') . '.' . a:dest)
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
