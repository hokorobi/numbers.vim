" File:           numbers.vim
" Maintainer:     Zhenhuan Hu <zhu@mcw.edu>
" Version:        1.0.1
" Description:    vim plugin for intelligently switching between absolute and
"                 relative line numbers.
" Last Change:    Feb 10, 2017
" License:        MIT License
" Location:       plugin/numbers.vim
"
" See numbers.txt for help. This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers

" LOAD GUARD: {{{1
if exists("g:loaded_numbers") || v:version < 800 || &cp
  finish
endif
let g:loaded_numbers = 1

" }}}1

" Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

" Initialization
let g:numbers_original_settings = [&number, &relativenumber]
let g:numbers_enable_at_startup = get(g:, 'numbers_enable_at_startup', 1)
let g:numbers_windows_excluded = get(g:, 'windows_excluded',
      \ ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree']
      \ )

" Commands
command! -nargs=0 NumbersEnable  call numbers#Enable()
command! -nargs=0 NumbersDisable call numbers#Disable()

if g:numbers_enable_at_startup
  NumbersEnable
endif

" Restore &cpo
let &cpo = s:save_cpo

" vim: set fdm=marker fdl=0:
