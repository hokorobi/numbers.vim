" Vim indent file
" Language:     SAS
" Maintainer:   Zhen-Huan Hu <zhu@mcw.edu>
" Last Change:  Aug 09, 2016

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
  let prev_lnum = prevnonblank(v:lnum - 1)
  let curr_line = getline(v:lnum)
  if prev_lnum ==# 0
    " Keep the indentation of the first line
    return indent(1)
  elseif curr_line =~ s:program_end
    " End of the program
    " Same indentation as the first non-blank line
    return indent(nextnonblank(1))
  elseif curr_line =~ s:macro_end
    " Current line is the end of a macro
    " Match the indentation of the start of the macro
    return indent(s:PrevMatch(v:lnum, s:macro_str))
  else
    let prev_line = getline(prev_lnum)
    " Previous non-blank line contains the start of a macro/section/block
    " while not the end of a macro/section/block (at the same line)
    if (prev_line =~ s:block_str && prev_line !~ s:block_end) ||
          \ (prev_line =~ s:section_str && prev_line !~ s:section_end) ||
          \ (prev_line =~ s:macro_str && prev_line !~ s:macro_end)
      let ind = indent(prev_lnum) + &sts
    else
      let ind = indent(prev_lnum)
    endif
    " Re-adjustments
    if curr_line =~ s:block_end && curr_line !~ s:block_str
      " Re-adjust if current line is the end of a block
      " while not the beginning of a block (at the same line)
      let ind = ind - &sts
    elseif curr_line =~ s:section_str || curr_line =~ s:section_end
      " Re-adjust if current line is the start/end of a section
      " since the end of a section could be inexplicit
      let prev_section_str_lnum = s:PrevMatch(v:lnum, s:section_str)
      let prev_section_end_lnum = max([
            \ s:PrevMatch(v:lnum, s:section_end),
            \ s:PrevMatch(v:lnum, s:macro_end),
            \ s:PrevMatch(v:lnum, s:program_end)])
      if prev_section_end_lnum < prev_section_str_lnum
        let ind = ind - &sts
      endif
    endif
    return ind
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
