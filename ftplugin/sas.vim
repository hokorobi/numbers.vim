" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal softtabstop=2 shiftwidth=2 expandtab conceallevel=3
setlocal hidden omnifunc=sascomplete#Complete

" Find autoexec files from $PATH
for syspath in split(expand('$PATH'), has('win32') ? ';' : ':')
  if filereadable(syspath . '/autoexec.sas')
    let &l:path = &path . ',' . syspath
  endif
endfor

" Restore view
augroup SASView
  autocmd!
  au BufWritePost,BufLeave,WinLeave *.sas mkview
  au BufWinEnter *.sas silent loadview
augroup END

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

" Set compiler
setlocal makeprg=sas\ -noverbose\ -sysin\ '%:p'

nnoremap <buffer> <silent> <F8> :call <SID>RunSAS()<CR>
vnoremap <buffer> <silent> <F8> :<C-u>call <SID>RunSAS()<CR>
inoremap <buffer> <silent> <F8> <C-o>:call <SID>RunSAS()<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments('/* ', ' */')<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments('/* ', ' */')<CR>
inoremap <buffer> <silent> <F5> <C-r>=keny#ToggleComments('/* ', ' */')<CR>

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

function! s:RunSAS()
  w
  call system("sas -noverbose -sysin '" . expand('%:p') . "'")
  if v:shell_error ==# 0
    echo 'All steps terminated normally'
  elseif v:shell_error ==# 1
    echohl WarningMsg | echo 'SAS System issued warning(s)' | echohl None
  elseif v:shell_error ==# 2
    echohl ErrorMsg | echo 'SAS System issued error(s)' | echohl None
  elseif v:shell_error ==# 3
    echo 'User issued the ABORT statement'
  elseif v:shell_error ==# 4
    echo 'User issued the ABORT RETURN statement'
  elseif v:shell_error ==# 5
    echo 'User issued the ABORT ABEND statement'
  elseif v:shell_error ==# 6
    echohl ErrorMsg | echo 'SAS internal error' | echohl None
  else
    echo 'Exit status code: ' . v:shell_error
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
