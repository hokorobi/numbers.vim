" File:           numbers.vim
" Maintainer:     Mahdi Yusuf <yusuf.mahdi@gmail.com>
"                 Zhenhuan Hu <zhu@mcw.edu>
" Version:        1.0.0
" Description:    vim plugin for intelligently switching between absolute and
"                 relative line numbers.
" Last Change:    Feb 06, 2017
" License:        MIT License
" Location:       plugin/numbers.vim
"
" See numbers.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers

" LOAD GUARD: {{{1
if exists("g:loaded_numbers") || v:version < 704 || &cp
  finish
endif
let g:loaded_numbers = 1

" }}}1

" Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

" Initialization
let g:numbers_save_number = [&number, &relativenumber]
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
