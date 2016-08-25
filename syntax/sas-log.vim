" Vim syntax file
" Language:     SAS log file
" Maintainer:   Zhenhuan Hu <zhu@mcw.edu>
" Last Change:  Aug 25, 2016

" Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match
syn match saslogNumber display "\v<\-=(\d+\.=\d*|\.\d+)(e\-=\d+)=>" contained
syn match saslogSplCmt display "\v<(uninitialized)>" contained
syn region saslogNote         matchgroup=saslogKeyword  start=/^NOTE:/         skip=/\n \{6}/  end=/$/ contains=saslogSplCmt
syn region saslogError        matchgroup=saslogKeyword  start=/^ERROR:/        skip=/\n \{7}/  end=/$/ contains=saslogSplCmt
syn region saslogWarning      matchgroup=saslogKeyword  start=/^WARNING:/      skip=/\n \{9}/  end=/$/ contains=saslogSplCmt
syn region saslogMacroSource  matchgroup=saslogMacroKwd start=/^MPRINT(\w\+):/ end=/$/ contains=saslogNumber
syn region saslogMacroLogic   matchgroup=saslogMacroKwd start=/^MLOGIC(\w\+):/ skip=/\n \{6}/  end=/$/
syn region saslogSymbolGen    matchgroup=saslogMacroKwd start=/^SYMBOLGEN:/    skip=/\n \{11}/ end=/$/

" The default highlighting.
hi def link saslogNote Comment
hi def link saslogMacroLogic Comment
hi def link saslogSymbolGen Comment
hi def link saslogError ErrorMsg
hi def link saslogWarning WarningMsg
hi def link saslogNumber Number
hi def link saslogKeyword Special
hi def link saslogMacroKwd Macro
hi def link saslogSplCmt SpecialComment

" Syncronize from beginning to keep large blocks from losing
" syntax coloring while moving through code.
syn sync fromstart

let b:current_syntax = "sas-log"

let &cpo = s:cpo_save
unlet s:cpo_save
