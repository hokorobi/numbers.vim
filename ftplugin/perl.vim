" Set compiler
nnoremap <buffer> <silent> <F8> :w !perl<CR>
vnoremap <buffer> <silent> <F8> :w !perl<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !perl<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments('# ')<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments('# ')<CR>
inoremap <buffer> <silent> <F5> <C-r>=keny#ToggleComments('# ')<CR>
