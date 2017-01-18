" Enable spell check
setlocal textwidth=78 formatoptions+=t spell spelllang=en_us

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments('<!-- ', ' -->')<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments('<!-- ', ' -->')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call keny#ToggleComments('<!-- ', ' -->')<CR>
