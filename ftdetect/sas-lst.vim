function! s:DetectNode()
  if len(findfile(expand('%<') . '.sas', '.')) > 0
    setfiletype sas-lst
  endif
endfunction

au BufNewFile,BufRead *.lst call s:DetectNode()
