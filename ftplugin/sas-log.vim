" Local functions
function! s:KenyFoldPageFeed()
  setlocal foldmethod=expr
  setlocal foldexpr=getline(v:lnum)[0]==\"\\<C-l>\"
  setlocal foldminlines=0
  setlocal foldtext='---\ New\ Page\ '
  setlocal foldlevel=0
  set foldclose=all
endfunction

" Automatic folding based on page feeds
augroup SASLogView
  autocmd!
  au BufWinEnter *.log call s:KenyFoldPageFeed()
augroup END

" Key mappings
nnoremap <buffer> <silent> <F2> :edit! %<.sas<CR>
vnoremap <buffer> <silent> <F2> :<C-u>edit! %<.sas<CR>
inoremap <buffer> <silent> <F2> <C-o>:edit! %<.sas<CR>

nnoremap <buffer> <silent> <F3> :view! %<.log<CR>
vnoremap <buffer> <silent> <F3> :<C-u>view! %<.log<CR>
inoremap <buffer> <silent> <F3> <C-o>:view! %<.log<CR>

nnoremap <buffer> <silent> <F4> :view! %<.lst<CR>
vnoremap <buffer> <silent> <F4> :<C-u>view! %<.lst<CR>
inoremap <buffer> <silent> <F4> <C-o>:view! %<.lst<CR>

