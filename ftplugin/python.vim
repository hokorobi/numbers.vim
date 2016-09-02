" Language specific indentation settings
setlocal softtabstop=4 shiftwidth=4 expandtab

" Set compiler
nnoremap <buffer> <silent> <F7> :w !python3<CR>
vnoremap <buffer> <silent> <F7> :w !python3<CR>
inoremap <buffer> <silent> <F7> <C-o>:w !python3<CR>

nnoremap <buffer> <silent> <F8> :w !python<CR>
vnoremap <buffer> <silent> <F8> :w !python<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !python<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call KenyToggleComment('# ')<CR>
vnoremap <buffer> <silent> <F5> :call KenyToggleComment('# ')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call KenyToggleComment('# ')<CR>
