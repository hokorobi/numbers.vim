" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal cms=#%s

" Set compiler
nnoremap <buffer> <silent> <F8> :w !perl<CR>
vnoremap <buffer> <silent> <F8> :w !perl<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !perl<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
inoremap <buffer> <silent> <F5> <C-r>=keny#ToggleComments()<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
