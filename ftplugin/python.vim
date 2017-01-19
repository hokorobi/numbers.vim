" Language specific indentation settings
setlocal softtabstop=4 shiftwidth=4 expandtab

" Set compiler
setlocal makeprg=python set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

nnoremap <buffer> <silent> <F8> :w !python<CR>
vnoremap <buffer> <silent> <F8> :w !python<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !python<CR>

nnoremap <buffer> <silent> <S-F8> :w !python3<CR>
vnoremap <buffer> <silent> <S-F8> :w !python3<CR>
inoremap <buffer> <silent> <S-F8> <C-o>:w !python3<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments('# ')<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments('# ')<CR>
inoremap <buffer> <silent> <F5> <C-r>=keny#ToggleComments('# ')<CR>
