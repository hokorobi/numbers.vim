function! s:DetectNode()
  if len(findfile(expand('%<') . '.sas', '.')) > 0
    set filetype=sas-lst
  endif
endfunction

au BufNewFile,BufRead *.lst call s:DetectNode()
