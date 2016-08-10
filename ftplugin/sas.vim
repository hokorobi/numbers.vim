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
nnoremap <buffer> <silent> <F8> :w<Bar>! sas -sysin '%:p'<CR>
vnoremap <buffer> <silent> <F8> :<C-u>w<Bar>! sas -sysin '%:p'<CR>
inoremap <buffer> <silent> <F8> <C-o>! sas -sysin '%:p'<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call KenyToggleComment('/* ', ' */')<CR>
vnoremap <buffer> <silent> <F5> :call KenyToggleComment('/* ', ' */')<CR>
inoremap <buffer> <silent> <F5> <C-o>:call KenyToggleComment('/* ', ' */')<CR>
