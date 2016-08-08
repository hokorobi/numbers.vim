" Set compiler
nnoremap <buffer> <silent> <F8> :w !perl<CR>
vnoremap <buffer> <silent> <F8> :w !perl<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !perl<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call KenyToggleComment('# ', '')<CR>
vnoremap <buffer> <silent> <F5> :call KenyToggleComment('# ', '')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call KenyToggleComment('# ', '')<CR>
