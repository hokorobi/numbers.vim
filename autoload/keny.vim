if exists('g:loaded_keny')
  finish
endif
let g:loaded_keny = 1

let s:save_cpo = &cpo
set cpo&vim

function! keny#ToggleComments()
  if getline('.') !~# '^\s*$'
    " Save the value of last search register
    let saved_last_search_pattern = @/
    " Retrieve leader and tail from &cms
    let escape_chars = '\/*'
    let [leader, tail] = map(split(substitute(substitute(
          \ &cms, '\S\zs%s',' %s','') ,'%s\ze\S', '%s ', ''), '%s', 1),
          \ 'escape(v:val, escape_chars)')
    " Toggle line comments
    if getline('.') =~# '^' . leader . '\(.*\)' . tail . '$'
      silent exec 's/^' . leader . '\(.*\)' . tail . '$/\1/'
    else
      silent exec 's/^\(.*\)$/' . leader . '\1' . tail . '/'
    endif
    " Restore the value of last search register
    " and thus remove highlighting of whitespaces
    let @/ = saved_last_search_pattern
  endif
  " Move cursor to the next line
  silent exec 'normal! +'
  return ''
endfunction

function! keny#SplitLinesNicely()
  " Save the value of last search register
  let saved_last_search_pattern = @/
  " This will highlight all whitespaces
  substitute /\s\+/\r/ge
  " Restore the value of last search register
  " and thus remove highlighting of whitespaces
  let @/ = saved_last_search_pattern
endfunction

function! keny#ShiftLineLeftRight(dir)
  let cur_pos = getpos('.')
  if a:dir < 0 && getline('.') =~# '^\s\+'
    let shift = getline('.') =~# '^\s\{' . shiftwidth() . ',}' ?
          \ shiftwidth() :
          \ len(matchstr(getline('.'), '^\s\+'))
    normal! v<
    let cur_pos[2] -= shift
  elseif a:dir > 0
    normal! v>
    let cur_pos[2] += shiftwidth()
  endif
  call cursor(cur_pos[1: 3])
  return ''
endfunction

function! keny#StripTrailingWhiteSpaces()
  " Save the value of last search register
  let saved_last_search_pattern = @/
  substitute /\s\+$//e
  " Restore the value of last search register
  " and thus remove highlighting of whitespaces
  let @/ = saved_last_search_pattern
endfunction

function! keny#MergeBlankLines()
  " Save the value of last search register
  let saved_last_search_pattern = @/
  substitute /\n\{3,}/\r\r/ge
  " Restore the value of last search register
  " and thus remove highlighting of whitespaces
  let @/ = saved_last_search_pattern
endfunction

function! keny#FoldSpellBalloon()
  let lines = []
  if foldclosed(v:beval_lnum) >= 0
    " If the cursor is on a fold
    let fold_start = foldclosed(v:beval_lnum)
    let fold_end = foldclosedend(v:beval_lnum)
    let n_lines_folded = fold_end - fold_start + 1
    " If too many lines in fold, show only the first 14
    " and the last 14 lines
    if (n_lines_folded > 31)
      let lines = getline(fold_start, fold_start + 14)
      let lines += ['-- Snipped ' . (n_lines_folded - 30) . ' lines --']
      let lines += getline(fold_end - 14, fold_end)
    else
      " If less than 30 lines, show all of them
      let lines = getline(fold_start, fold_end)
    endif
  elseif len(spellbadword(v:beval_text)[0]) > 0
    " If the cursor is on a misspelled word
    let lines = spellsuggest(spellbadword(v:beval_text)[0], 5, 0)
  endif
  return join(lines, has("balloon_multiline") ? "\n" : " ")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
