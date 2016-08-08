" Vim indent file
" Language:     SAS
" Maintainer:   Zhen-Huan Hu <zhu@mcw.edu>
" Last Change:  Aug 08, 2016

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetSASIndent()
setlocal indentkeys+=;,=~data,=~proc,=~macro

if exists("*GetSASIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Regex that defines the start of a macro
let s:macro_str = '^\s*%macro\>'
" Regex that defines the end of a macro
let s:macro_end = '^\s*%mend;'

" Regex that defines the start of a data/proc section
let s:section_str = '\v(^|;)@<=\s*(data|proc)>'
" Regex that defines the end of a data/proc section
let s:section_end = '\v(^|;)@<=\s*(run|quit|enddata);'

" Regex that defines the start of a conditional block
let s:block_str = '\v<(do( .+<to>.+| <over>.+)?|select( \(.+\))?|(define|layout|method) .+|begingraph);'
" Regex that defines the end of a conditional block
let s:block_end = '\v(^|;)@<=\s*\%?(end|endlayout|endgraph);'

" Regex that defines the end of the program
let s:program_end = '\v(^|;)@<=\s*endsas;'

" Find the line number of previous keyword defined by the regex
function! s:PrevMatch(lnum, regex)
  let prev_lnum = prevnonblank(a:lnum - 1)
  while prev_lnum > 0
    if getline(prev_lnum) =~ a:regex
      break
    else
      let prev_lnum = prevnonblank(prev_lnum - 1)
    endif
  endwhile
  return prev_lnum
endfunction

" Main function
function! GetSASIndent()
  let prev_ind  = indent(prevnonblank(v:lnum - 1))
  let prev_line = getline(prevnonblank(v:lnum - 1))
  let curr_line = getline(v:lnum)

  " Start/end of the program
  if v:lnum == 0 || curr_line =~ s:program_end
    return 0
  endif

  " Current line is the end of a macro
  if curr_line =~ s:macro_end
    let prev_macro_str_lnum = s:PrevMatch(v:lnum, s:macro_str)
    return indent(prev_macro_str_lnum)
  endif

  " Previous non-blank line contains the start of a macro/section/block
  " while not the end of a macro/section/block (at the same line)
  if (prev_line =~ s:block_str && prev_line !~ s:block_end)
        \ || (prev_line =~ s:section_str && prev_line !~ s:section_end)
        \ || (prev_line =~ s:macro_str && prev_line !~ s:macro_end)
    let ind = prev_ind + &sts
  else
    let ind = prev_ind
  endif

  " Re-adjust if current line is the end of a block
  " while not the beginning of a block
  if curr_line =~ s:block_end && curr_line !~ s:block_str
    return ind - &sts
  endif
  
  " Re-adjust if current line is the start/end of a section
  if curr_line =~ s:section_str || curr_line =~ s:section_end
    let prev_str_lnum = s:PrevMatch(v:lnum, s:section_str)
    let prev_end_lnum = max([s:PrevMatch(v:lnum, s:section_end),
          \s:PrevMatch(v:lnum, s:macro_end),
          \s:PrevMatch(v:lnum, s:program_end)])
    if prev_end_lnum < prev_str_lnum
      return ind - &sts
    endif
  endif

  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
