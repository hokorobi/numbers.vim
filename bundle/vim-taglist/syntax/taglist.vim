" Vim syntax file
" Language:	TagList
" Maintainer:	Zhenhuan Hu <zhu@mcw.edu>
" Last Change:	

" Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Define taglist window element highlighting
syntax match TagListComment '^" .*'
syntax match TagListFileName '^[^" ].*$'
syntax match TagListTitle '^  \S.*$'
syntax match TagListTagScope '\s\[.\{-\}\]$'

" Define the highlighting only if colors are supported
if has('gui_running') || &t_Co > 2
  " Colors to highlight various taglist window elements
  " If user defined highlighting group exists, then use them.
  " Otherwise, use default highlight groups.
  if hlexists('MyTagListTagName')
    highlight link TagListTagName MyTagListTagName
  else
    highlight default link TagListTagName Search
  endif
  " Colors to highlight comments and titles
  if hlexists('MyTagListComment')
    highlight link TagListComment MyTagListComment
  else
    highlight clear TagListComment
    highlight default link TagListComment Comment
  endif
  if hlexists('MyTagListTitle')
    highlight link TagListTitle MyTagListTitle
  else
    highlight clear TagListTitle
    highlight default link TagListTitle Title
  endif
  if hlexists('MyTagListFileName')
    highlight link TagListFileName MyTagListFileName
  else
    highlight clear TagListFileName
    highlight default link TagListFileName Include
  endif
  if hlexists('MyTagListTagScope')
    highlight link TagListTagScope MyTagListTagScope
  else
    highlight clear TagListTagScope
    highlight default link TagListTagScope Identifier
  endif
else
  highlight default TagListTagName term=reverse cterm=reverse
endif

let b:current_syntax = 'taglist'

let &cpo = s:cpo_save
unlet s:cpo_save
