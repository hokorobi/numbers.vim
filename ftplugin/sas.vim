" Local functions
function! s:KenyRunSAS()
  w
  call system("sas -noverbose -sysin '" . expand('%:p') . "'")
  if v:shell_error ==# 0
    echo 'All steps terminated normally'
  elseif v:shell_error ==# 1
    echo 'SAS System issued warning(s)'
  elseif v:shell_error ==# 2
    echo 'SAS System issued error(s)'
  elseif v:shell_error ==# 3
    echo 'User issued the ABORT statement'
  elseif v:shell_error ==# 4
    echo 'User issued the ABORT RETURN statement'
  elseif v:shell_error ==# 5
    echo 'User issued the ABORT ABEND statement'
  elseif v:shell_error ==# 6
    echo 'SAS internal error'
  else
    echo 'Exit status code: ' . v:shell_error
  endif
endfunction

" Automatic folding when reopening
augroup SASView
  autocmd!
  au BufWritePost,BufLeave,WinLeave *.sas mkview 
  au BufWinEnter *.sas silent loadview
augroup END

" Key mappings
nnoremap <buffer> <silent> <F2> :edit %<.sas<CR>
vnoremap <buffer> <silent> <F2> :<C-u>edit %<.sas<CR>
inoremap <buffer> <silent> <F2> <C-o>:edit %<.sas<CR>

nnoremap <buffer> <silent> <F3> :view %<.log<CR>
vnoremap <buffer> <silent> <F3> :<C-u>view %<.log<CR>
inoremap <buffer> <silent> <F3> <C-o>:view %<.log<CR>

nnoremap <buffer> <silent> <F4> :view %<.lst<CR>
vnoremap <buffer> <silent> <F4> :<C-u>view %<.lst<CR>
inoremap <buffer> <silent> <F4> <C-o>:view %<.lst<CR>

" Set compiler
nnoremap <buffer> <silent> <F8> :call <SID>KenyRunSAS()<CR>
vnoremap <buffer> <silent> <F8> :<C-u>call <SID>KenyRunSAS()<CR>
inoremap <buffer> <silent> <F8> <C-o>:call <SID>KenyRunSAS()<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call KenyToggleComment('/* ', ' */')<CR>
vnoremap <buffer> <silent> <F5> :call KenyToggleComment('/* ', ' */')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call KenyToggleComment('/* ', ' */')<CR>
