fun! s:DetectNode()
  if getline(1) =~ 'The SAS System'
    set ft=sas-log
  endif
endfun

au BufNewFile,BufRead *.log call s:DetectNode()
