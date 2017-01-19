" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Key mappings
nnoremap <buffer> <silent> <F2> :edit! %<.sas<CR>
vnoremap <buffer> <silent> <F2> :<C-u>edit! %<.sas<CR>
inoremap <buffer> <silent> <F2> <C-o>:edit! %<.sas<CR>

nnoremap <buffer> <silent> <F3> :view! %<.log<CR>
vnoremap <buffer> <silent> <F3> :<C-u>view! %<.log<CR>
inoremap <buffer> <silent> <F3> <C-o>:view! %<.log<CR>

nnoremap <buffer> <silent> <F4> :view! %<.lst<CR>
vnoremap <buffer> <silent> <F4> :<C-u>view! %<.lst<CR>
inoremap <buffer> <silent> <F4> <C-o>:view! %<.lst<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
