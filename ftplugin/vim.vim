" Set comment toggle
nnoremap <buffer> <silent> <F5> :call KenyToggleComment('" ')<CR>
vnoremap <buffer> <silent> <F5> :call KenyToggleComment('" ')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call KenyToggleComment('" ')<CR>
