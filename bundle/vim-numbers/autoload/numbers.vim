" File:           numbers.vim
" Maintainer:     Zhenhuan Hu <zhu@mcw.edu>
" Version:        1.0.1
" Description:    vim plugin for automatic switching between absolute and
"                 relative line numbers.
" Last Change:    Feb 10, 2017
" License:        MIT License
" Location:       autoload/numbers.vim
"
" See numbers.txt for help. This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers

" Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

" LOAD GUARD: {{{1
if exists('g:loaded_autoload_numbers') || v:version < 704 || &cp
  finish
endif
let g:loaded_autoload_numbers = 1

" }}}1

" GLOCAL FUNCTIONS: {{{1
function! numbers#Enable()
  augroup NumbersAutoCommand
    autocmd!
    autocmd InsertEnter * :call s:RelativeNumberOff()
    autocmd InsertLeave * :call s:RelativeNumberOn()
    autocmd BufNewFile  * :call s:ResetNumbers()
    autocmd BufReadPost * :call s:ResetNumbers()
    autocmd FocusGained * :call s:Focused()
    autocmd FocusLost   * :call s:UnFocused()
    autocmd VimEnter    * :call s:Focused()
    autocmd WinEnter    * :call s:Focused()
    autocmd WinLeave    * :call s:UnFocused()
  augroup END
endfunction

function! numbers#Disable()
  let [&number, &relativenumber] = g:numbers_original_settings
  augroup NumbersAutoCommand
    autocmd!
  augroup END
endfunction

" }}}1

" INTERNAL FUNCTIONS: {{{1
function! s:RelativeNumberOff()
  if index(g:numbers_windows_excluded, &ft) >= 0 || (&number == 0 && &relativenumber == 0)
    return
  endif
  set number norelativenumber
endfunction

function! s:RelativeNumberOn()
  if index(g:numbers_windows_excluded, &ft) >= 0 || (&number == 0 && &relativenumber == 0)
    return
  endif
  set number relativenumber
endfunction

function! s:Focused()
  let s:focused[win_getid()] = 1
  call s:ResetNumbers()
endfunction

function! s:UnFocused()
  let s:focused[win_getid()] = 0
  call s:RelativeNumberOff()
endfunction

function! s:ResetNumbers()
  if has_key(s:focused, win_getid()) &&
        \ s:focused[win_getid()] == 0
    call s:RelativeNumberOff()
  elseif mode() ==# 'i'
    call s:RelativeNumberOff()
  else
    call s:RelativeNumberOn()
  endif
endfunction

" }}}1

" Initialization
let s:focused = {}

" Restore &cpo
let &cpo = s:save_cpo

" vim: set fdm=marker fdl=0:
