" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments('" ')<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments('" ')<CR>
inoremap <buffer> <silent> <F5> <C-r>=keny#ToggleComments('" ')<CR>
