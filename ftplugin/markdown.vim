" Enable spell check
setlocal textwidth=78 formatoptions+=t spell spelllang=en_us

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call KenyToggleComment('<!-- ', ' -->')<CR>
vnoremap <buffer> <silent> <F5> :call KenyToggleComment('<!-- ', ' -->')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call KenyToggleComment('<!-- ', ' -->')<CR>
