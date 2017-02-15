" File: taglist.vim
" Maintainer: Zhenhuan Hu (zhu@mcw.edu)
" Original Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 5.0.0
" Last Modified: Feb 14, 2017
" Copyright: Copyright (C) 2002-2013 Yegappan Lakshmanan
"                          2017      Zhenhuan Hu
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            taglist.vim is provided *as is* and comes with no warranty of any
"            kind, either expressed or implied. In no event will the copyright
"            holder be liable for any damamges resulting from the use of this
"            software.

" LOAD GUARD: {{{1
if exists('g:loaded_autoload_taglist') || !exists('*system')
  finish
endif
let g:loaded_autoload_taglist = 1

" }}}1

" Save cpoptions.
let s:cpo_save = &cpo
set cpo&vim

" LANGUAGE SETTINGS: {{{1
"       s:tlist_def_settings
"
" Key         - File type detected by Vim
"
" Value format:
"
"       <ctags_ftype>;<flag>:<name>;<flag>:<name>;...
"
" ctags_ftype - File type supported by exuberant ctags
" flag        - Flag supported by exuberant ctags to generate a tag type
" name        - Name of the tag type used in the taglist window to display the
"               tags of this type

let s:tlist_def_settings = {
      \ 'ant'       : 'ant;p:projects;t:targets;',
      \ 'asm'       : 'asm;d:define;l:label;m:macro;t:type;',
      \ 'asp'       : 'asp;c:constants;v:variable;f:function;s:subroutine;',
      \ 'aspvbs'    : 'asp;c:constants;v:variable;f:function;s:subroutine;',
      \ 'awk'       : 'awk;f:function;',
      \ 'basic'     : 'basic;c:constant;l:label;g:enum;v:variable;' .
      \               't:type;f:function;',
      \ 'beta'      : 'beta;f:fragment;s:slot;v:pattern;',
      \ 'c'         : 'c;d:macro;g:enum;s:struct;u:union;t:typedef;' .
      \               'v:variable;f:function;',
      \ 'cpp'       : 'c++;n:namespace;v:variable;d:macro;t:typedef;' .
      \               'c:class;g:enum;s:struct;u:union;f:function;',
      \ 'cs'        : 'c#;d:macro;t:typedef;n:namespace;c:class;' .
      \               'E:event;g:enum;s:struct;i:interface;' .
      \               'p:properties;m:method;',
      \ 'cobol'     : 'cobol;d:data;f:file;g:group;p:paragraph;' .
      \               'P:program;s:section;',
      \ 'd'         : 'c++;n:namespace;v:variable;t:typedef;' .
      \               'c:class;g:enum;s:struct;u:union;f:function;',
      \ 'dosbatch'  : 'dosbatch;l:labels;v:variables;',
      \ 'eiffel'    : 'eiffel;c:class;f:feature;',
      \ 'erlang'    : 'erlang;d:macro;r:record;m:module;f:function;',
      \ 'flex'      : 'flex;v:global;c:classes;p:properties;' .
      \               'm:methods;f:functions;x:mxtags;',
      \ 'fortran'   : 'fortran;p:program;b:block data;' .
      \               'c:common;e:entry;i:interface;k:type;l:label;m:module;' .
      \               'n:namelist;t:derived;v:variable;f:function;s:subroutine;',
      \ 'go'        : 'go;f:function;p:package;t:struct;',
      \ 'html'      : 'html;a:anchor;f:function;',
      \ 'java'      : 'java;p:package;c:class;i:interface;g:enum;f:field;m:method;',
      \ 'javascript': 'javascript;c:class;m:method;v:global;f:function;p:properties;',
      \ 'lisp'      : 'lisp;f:function;',
      \ 'lua'       : 'lua;f:function;',
      \ 'make'      : 'make;m:macro;',
      \ 'matlab'    : 'matlab;f:function;',
      \ 'ocamal'    : 'ocamal;M:module;v:global;t:type;' .
      \               'c:class;f:function;m:method;C:constructor;e:exception;',
      \ 'pascal'    : 'pascal;f:function;p:procedure;',
      \ 'perl'      : 'perl;c:constant;l:label;p:package;s:subroutine;',
      \ 'php'       : 'php;c:class;i:interface;d:constant;v:variable;f:function;',
      \ 'python'    : 'python;c:class;m:member;f:function;',
      \ 'pyrex'     : 'python;c:class;m:memder;f:function;',
      \ 'rexx'      : 'rexx;s:subroutine;',
      \ 'ruby'      : 'ruby;c:class;f:method;F:function;m:singleton method;',
      \ 'scheme'    : 'scheme;s:set;f:function;',
      \ 'sh'        : 'sh;f:function;',
      \ 'csh'       : 'sh;f:function;',
      \ 'zsh'       : 'sh;f:function;',
      \ 'slang'     : 'slang;n:namespace;f:function;',
      \ 'sml'       : 'sml;e:exception;c:functor;s:signature;' .
      \               'r:structure;t:type;v:value;c:functor;f:function;',
      \ 'sql'       : 'sql;f:functions;' .
      \               'P:packages;p:procedures;t:tables;T:triggers;' .
      \               'v:variables;e:events;U:publications;R:services;' .
      \               'D:domains;x:MLTableScripts;y:MLConnScripts;z:MLProperties;'.
      \               'i:indexes;c:cursors;V:views;d:prototypes;'.
      \               'l:local variables;F:record fields;'.
      \               'L:block label;r:records;s:subtypes;',
      \ 'tcl'       : 'tcl;c:class;f:method;m:method;p:procedure;',
      \ 'expect'    : 'tcl;c:class;f:method;p:procedure;',
      \ 'tex'       : 'tex;c:chapters;s:sections;u:subsections;'.
      \               'b:subsubsections;p:parts;P:paragraphs;G:subparagraphs;',
      \ 'vera'      : 'vera;c:class;d:macro;e:enumerator;' .
      \               'f:function;g:enum;m:member;p:program;' .
      \               'P:prototype;t:task;T:typedef;v:variable;' .
      \               'x:externvar;',
      \ 'verilog'   : 'verilog;m:module;c:constant;P:parameter;' .
      \               'e:event;r:register;t:task;w:write;p:port;v:variable;f:function;',
      \ 'vhdl'      : 'vhdl;c:constant;t:type;T:subtype;r:record;' .
      \               'e:entity;f:function;p:procedure;P:package;',
      \ 'vim'       : 'vim;v:variable;a:autocmds;c:commands;m:map;f:function;',
      \ 'yacc'      : 'yacc;l:label;',
      \ }
" }}}1

" INITIALIZATION: {{{1
" Taglist debug support
let s:tlist_debug = 0
" File for storing the debug messages
let s:tlist_debug_file = ''
" Vim window size is changed by the taglist plugin or not
let s:tlist_winsize_chgd = -1
" Taglist window is maximized or not
let s:tlist_win_maximized = 0
" Dictionary of the status of files
let s:tlist_file_dict = {}
" Name of files in the taglist
let s:tlist_file_names = ''
" Number of files in the taglist
let s:tlist_file_count = 0
" Number of filetypes supported by taglist
let s:tlist_ftype_count = 0
" Is taglist part of other plugins like winmanager or cream?
let s:tlist_app_name = 'none'
" Are we displaying brief help text
let s:tlist_brief_help = 1
" List of files removed on user request
let s:tlist_removed_flist = []
" Index of current file displayed in the taglist window
let s:tlist_cur_file_idx = -1
" Taglist menu is empty or not
let s:tlist_menu_empty = 1
" An autocommand is used to refresh the taglist window when entering any
" buffer. We don't want to refresh the taglist window if we are entering the
" file window from one of the taglist functions. The 'tlist_skip_refresh'
" variable is used to skip the refresh of the taglist window and is set
" and cleared appropriately.
let s:tlist_skip_refresh = 0
" Last returned file index for file name lookup.
" Used to speed up file lookup
let s:tlist_file_name_idx_cache = -1
" Last returned file index for line number lookup.
" Used to speed up file lookup
let s:tlist_file_lnum_idx_cache = -1

let s:menu_char_prefix =
      \ '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
" }}}1

" GLOBAL FUNCTIONS: {{{1
" Initialize the taglist menu
function! taglist#MenuInit()
  call s:MenuAddBaseMenu()
  " Automatically add the tags defined in the current file to the menu
  augroup TagListMenuCmds
    autocmd!
    if !g:tlist_process_file_always
      autocmd BufEnter,BufWritePost,FileChangedShellPost * call taglist#Refresh()
    endif
    autocmd BufLeave * call s:MenuRemoveFile()
  augroup END
  call s:MenuUpdateFile(0)
endfunction

" Refresh the taglist
function! taglist#Refresh()
  call s:LogMsg('Refresh(tlist_skip_refresh = ' .
        \ s:tlist_skip_refresh . ', ' . bufname('%') . ')')
  " Skip buffers with 'buftype' set to nofile, nowrite, quickfix or help
  if &buftype != ''
    return
  endif
  " If we are entering the buffer from one of the taglist functions, then
  " no need to refresh the taglist window again.
  if s:tlist_skip_refresh
    " We still need to update the taglist menu
    if g:tlist_show_menu
      call s:MenuUpdateFile(0)
    endif
    return
  endif
  " If part of the winmanager plugin and not configured to process
  " tags always and not configured to display the tags menu, then return
  if (s:tlist_app_name == 'winmanager') &&
        \ !g:tlist_process_file_always &&
        \ !g:tlist_show_menu
    return
  endif
  let filename = fnamemodify(bufname('%'), ':p')
  let ftype = s:GetBufferFileType(bufname('%'))
  " If the file doesn't support tag listing, skip it
  if s:SkipFile(filename, ftype)
    return
  endif
  let tlist_winnr = bufwinnr(g:TagList_title)
  " If the taglist window is not opened and not configured to process
  " tags always and not displaying the tags menu, then return
  if tlist_winnr == -1 && !g:tlist_process_file_always && !g:tlist_show_menu
    return
  endif
  let fidx = s:GetFileIndex(filename)
  if fidx == -1
    " Check whether this file is removed based on user request
    " If it is, then don't display the tags for this file
    if s:IsRemovedFile(filename)
      return
    endif
    " If the taglist should not be auto updated, then return
    if !g:tlist_auto_update
      return
    endif
  endif
  let cur_lnum = line('.')
  if fidx == -1
    " Update the tags for the file
    let fidx = s:ProcessFile(filename, ftype)
  else
    let mtime = getftime(filename)
    if s:tlist_{fidx}_mtime != mtime
      " Invalidate the tags listed for this file
      let s:tlist_{fidx}_valid = 0
      " Update the taglist and the window
      call UpdateFile(filename, ftype)
      " Store the new file modification time
      let s:tlist_{fidx}_mtime = mtime
    endif
  endif
  " Update the taglist window
  if tlist_winnr != -1
    " Disable screen updates
    let old_lazyredraw = &lazyredraw
    set nolazyredraw
    " Save the current window number
    let save_winnr = winnr()
    " Goto the taglist window
    call s:WindowGotoWindow()
    if !g:tlist_auto_highlight_tag || !g:tlist_highlight_tag_on_bufenter
      " Save the cursor position
      let save_line = line('.')
      let save_col = col('.')
    endif
    " Update the taglist window
    call s:WindowRefreshFile(filename, ftype)
    " Open the fold for the file
    exe "silent! " . s:tlist_{fidx}_start . "," .
          \ s:tlist_{fidx}_end . "foldopen!"
    if g:tlist_highlight_tag_on_bufenter && g:tlist_auto_highlight_tag
      if g:tlist_show_one_file && s:tlist_cur_file_idx != fidx
        " If displaying tags for only one file in the taglist
        " window and about to display the tags for a new file,
        " then center the current tag line for the new file
        let center_tag_line = 1
      else
        let center_tag_line = 0
      endif
      " Highlight the current tag
      call s:WindowHighlightTag(filename, cur_lnum, 1, center_tag_line)
    else
      " Restore the cursor position
      if v:version >= 601
        call cursor(save_line, save_col)
      else
        exe save_line
        exe 'normal! ' . save_col . '|'
      endif
    endif
    " Jump back to the original window
    if save_winnr != winnr()
      call s:ExeCmdWithoutAcmds(save_winnr . 'wincmd w')
    endif
    " Restore screen updates
    let &lazyredraw = old_lazyredraw
  endif
  " Update the taglist menu
  if g:tlist_show_menu
    call s:MenuUpdateFile(0)
  endif
endfunction

" A buffer is removed from the Vim buffer list. Remove the tags defined
" for that file
function! taglist#BufferRemoved(filename)
  call s:LogMsg('BufferRemoved(' . a:filename .  ')')
  " Make sure a valid filename is supplied
  if a:filename == ''
    return
  endif
  " Get tag list index of the specified file
  let fidx = s:GetFileIndex(a:filename)
  if fidx == -1
    " File not present in the taglist
    return
  endif
  " Remove the file from the list
  call s:RemoveFile(fidx, 0)
endfunction

" Initialize the taglist window/buffer, which is created when loading
" a Vim session file.
function! taglist#VimSessionLoad()
  call s:LogMsg('VimSessionLoad')
  " Initialize the taglist window
  call s:WindowInit()
  " Refresh the taglist window
  call s:WindowRefresh()
endfunction

" Open and refresh the taglist window
function! taglist#WindowOpen()
  call s:LogMsg('WindowOpen()')
  " If the window is open, jump to it
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    " Jump to the existing window
    if winnr() != tlist_winnr
      exe tlist_winnr . 'wincmd w'
    endif
    return
  endif
  if s:tlist_app_name == 'winmanager'
    " Taglist plugin is no longer part of the winmanager app
    let s:tlist_app_name = 'none'
  endif
  " Get the filename and filetype for the specified buffer
  let curbuf_name = fnamemodify(bufname('%'), ':p')
  let curbuf_ftype = s:GetBufferFileType(bufname('%'))
  let cur_lnum = line('.')
  " Mark the current window as the desired window to open a file when a tag
  " is selected.
  call s:WindowMarkFileWindow()
  " Open the taglist window
  call s:WindowCreate()
  call s:WindowRefresh()
  if g:tlist_show_one_file
    " Add only the current buffer and file
    " If the file doesn't support tag listing, skip it
    if !s:SkipFile(curbuf_name, curbuf_ftype)
      call s:WindowRefreshFile(curbuf_name, curbuf_ftype)
    endif
  endif
  if g:tlist_file_fold_auto_close
    " Open the fold for the current file, as all the folds in
    " the taglist window are closed
    let fidx = s:GetFileIndex(curbuf_name)
    if fidx != -1
      exe 'silent! ' . s:tlist_{fidx}_start . ',' .
            \ s:tlist_{fidx}_end . 'foldopen!'
    endif
  endif
  " Highlight the current tag
  call s:WindowHighlightTag(curbuf_name, cur_lnum, 1, 1)
endfunction

" Close the taglist window
function! taglist#WindowClose()
  call s:LogMsg('WindowClose()')
  " Make sure the taglist window exists
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    call s:WarningMsg('Error: Taglist window is not open')
    return
  endif
  if winnr() == tlist_winnr
    " Already in the taglist window. Close it and return
    if winbufnr(2) != -1
      " If a window other than the taglist window is open,
      " then only close the taglist window.
      close
    endif
  else
    " Goto the taglist window, close it and then come back to the
    " original window
    let curbufnr = bufnr('%')
    exe tlist_winnr . 'wincmd w'
    close
    " Need to jump back to the original window only if we are not
    " already in that window
    let winnum = bufwinnr(curbufnr)
    if winnr() != winnum
      exe winnum . 'wincmd w'
    endif
  endif
endfunction

" Open or close a taglist window
function! taglist#WindowToggle()
  call s:LogMsg('WindowToggle()')
  " If taglist window is open then close it.
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    call taglist#WindowClose()
    return
  endif
  call taglist#WindowOpen()
  " Go back to the original window, if tlist_gain_focus_on_toggleopen is not
  " set
  if !g:tlist_gain_focus_on_toggleopen
    call s:ExeCmdWithoutAcmds('wincmd p')
  endif
  " Update the taglist menu
  if g:tlist_show_menu
    call s:MenuUpdateFile(0)
  endif
endfunction

" Open the taglist window automatically on Vim startup.
" Open the window only when files present in any of the Vim windows support
" tags.
function! taglist#WindowCheckAutoOpen()
  let open_window = 0
  let i = 1
  let bufnum = winbufnr(i)
  while bufnum != -1
    let filename = fnamemodify(bufname(bufnum), ':p')
    let ft = s:GetBufferFileType(bufnum)
    if !s:SkipFile(filename, ft)
      let open_window = 1
      break
    endif
    let i += 1
    let bufnum = winbufnr(i)
  endwhile
  if open_window
    call taglist#WindowToggle()
  endif
endfunction

" Add the specified list of files to the taglist
function! taglist#AddFiles(...)
  let flist = ''
  let i = 1
  " Get all the files matching the file patterns supplied as argument
  while i <= a:0
    let flist = flist . glob(a:{i}) . "\n"
    let i = i + 1
  endwhile
  if flist == ''
    call s:WarningMsg('Error: No matching files are found')
    return
  endif
  let fcnt = s:ProcessFilelist(flist)
  echon "\rAdded " . fcnt . " files to the taglist"
endfunction

" Add files recursively from a directory
function! taglist#AddFilesRecursive(dir, ...)
  let dir_name = fnamemodify(a:dir, ':p')
  if !isdirectory(dir_name)
    call s:WarningMsg('Error: ' . dir_name . ' is not a directory')
    return
  endif
  if a:0 == 1
    " User specified file pattern
    let pat = a:1
  else
    " Default file pattern
    let pat = '*'
  endif
  echon "\r                                                              "
  echon "\rProcessing files in directory " . fnamemodify(dir_name, ':t')
  let fcnt = s:ProcessDir(dir_name, pat)
  echon "\rAdded " . fcnt . " files to the taglist"
endfunction

" Update taglist for the current buffer by regenerating the tag list
" Contributed by WEN Guopeng.
function! taglist#UpdateCurrentFile()
  call s:LogMsg('UpdateCurrentFile()')
  if winnr() == bufwinnr(g:TagList_title)
    " In the taglist window. Update the current file
    call s:WindowUpdateFile()
  else
    " Not in the taglist window. Update the current buffer
    let filename = fnamemodify(bufname('%'), ':p')
    let fidx = s:GetFileIndex(filename)
    if fidx != -1
      let s:tlist_{fidx}_valid = 0
    endif
    let ft = s:GetBufferFileType(bufname('%'))
    call UpdateFile(filename, ft)
  endif
endfunction

" Get the prototype for the tag on or before the specified line number in the
" current buffer
function! taglist#GetTagPrototypeByLine(...)
  if a:0 == 0
    " Arguments are not supplied. Use the current buffer name
    " and line number
    let filename = bufname('%')
    let linenr = line('.')
  elseif a:0 == 2
    " Filename and line number are specified
    let filename = a:1
    let linenr = a:2
    if linenr !~ '\d\+'
      " Invalid line number
      return ""
    endif
  else
    " Sufficient arguments are not supplied
    call s:WarningMsg('Usage: GetTagPrototypeByLine <filename> <line_number>')
    return ""
  endif
  " Expand the file to a fully qualified name
  let filename = fnamemodify(filename, ':p')
  if filename == ''
    return ""
  endif
  let fidx = s:GetFileIndex(filename)
  if fidx == -1
    return ""
  endif
  " If there are no tags for this file, then no need to proceed further
  if s:tlist_{fidx}_tag_count == 0
    return ""
  endif
  " Get the tag text using the line number
  let tidx = s:FindNearestTagIdx(fidx, linenr)
  if tidx == -1
    return ""
  endif
  return s:GetTagPrototype(fidx, tidx)
endfunction

" Get the tag name on or before the specified line number in the
" current buffer
function! taglist#GetTagnameByLine(...)
  if a:0 == 0
    " Arguments are not supplied. Use the current buffer name
    " and line number
    let filename = bufname('%')
    let linenr = line('.')
  elseif a:0 == 2
    " Filename and line number are specified
    let filename = a:1
    let linenr = a:2
    if linenr !~ '\d\+'
      " Invalid line number
      return ""
    endif
  else
    " Sufficient arguments are not supplied
    call s:WarningMsg('Usage: GetTagnameByLine <filename> <line_number>')
    return ""
  endif
  " Make sure the current file has a name
  let filename = fnamemodify(filename, ':p')
  if filename == ''
    return ""
  endif
  let fidx = s:GetFileIndex(filename)
  if fidx == -1
    return ""
  endif
  " If there are no tags for this file, then no need to proceed further
  if s:tlist_{fidx}_tag_count == 0
    return ""
  endif
  " Get the tag name using the line number
  let tidx = s:FindNearestTagIdx(fidx, linenr)
  if tidx == -1
    return ""
  endif
  let name = s:tlist_{fidx}_{tidx}_tag_name
  if g:tlist_display_tag_scope
    " Add the scope of the tag
    let tag_scope = s:tlist_{fidx}_{tidx}_tag_scope
    if tag_scope != ''
      let name = name . ' [' . tag_scope . ']'
    endif
  endif
  return name
endfunction

" Load a taglist session (information about all the displayed files
" and the tags) from the specified file
function! taglist#SessionLoad(...)
  if a:0 == 0 || a:1 == ''
    call s:WarningMsg('Usage: SessionLoad <filename>')
    return
  endif
  let sessionfile = a:1
  if !filereadable(sessionfile)
    call s:WarningMsg('Error - Unable to open file ' . sessionfile)
    return
  endif
  " Mark the current window as the file window
  call s:WindowMarkFileWindow()
  " Source the session file
  exe 'source ' . sessionfile
  let new_file_count = g:tlist_file_count
  unlet! g:tlist_file_count
  let i = 0
  while i < new_file_count
    let ftype = g:tlist_{i}_filetype
    unlet! g:tlist_{i}_filetype
    if !exists('s:tlist_session_settings[ftype]')
      if s:InitFileTypeSettings(ftype) == 0
        let i += 1
        continue
      endif
    endif
    let fname = g:tlist_{i}_filename
    unlet! g:tlist_{i}_filename
    let fidx = s:GetFileIndex(fname)
    if fidx != -1
      let s:tlist_{fidx}_visible = 0
      let i = i + 1
      continue
    else
      " As we are loading the tags from the session file, if this
      " file was previously deleted by the user, now we need to
      " add it back. So remove the file from the deleted list.
      call s:UpdateRemovedFileList(fname, 0)
    endif
    let fidx = s:InitFile(fname, ftype)
    let s:tlist_{fidx}_filename = fname
    let s:tlist_{fidx}_sort_type = g:tlist_{i}_sort_type
    unlet! g:tlist_{i}_sort_type
    let s:tlist_{fidx}_filetype = ftype
    let s:tlist_{fidx}_mtime = getftime(fname)
    let s:tlist_{fidx}_start = 0
    let s:tlist_{fidx}_end = 0
    let s:tlist_{fidx}_valid = 1
    let s:tlist_{fidx}_tag_count = g:tlist_{i}_tag_count
    unlet! g:tlist_{i}_tag_count
    let j = 1
    while j <= s:tlist_{fidx}_tag_count
      let s:tlist_{fidx}_{j}_tag = g:tlist_{i}_{j}_tag
      let s:tlist_{fidx}_{j}_tag_name = g:tlist_{i}_{j}_tag_name
      let s:tlist_{fidx}_{j}_ttype_idx = g:tlist_{i}_{j}_ttype_idx
      unlet! g:tlist_{i}_{j}_tag
      unlet! g:tlist_{i}_{j}_tag_name
      unlet! g:tlist_{i}_{j}_ttype_idx
      let j = j + 1
    endwhile
    for ttype in keys(s:tlist_session_settings[ftype]['flags'])
      if exists('g:tlist_' . i . '_' . ttype)
        let s:tlist_{fidx}_{ttype} = g:tlist_{i}_{ttype}
        unlet! g:tlist_{i}_{ttype}
        let s:tlist_{fidx}_{ttype}_offset = 0
        let s:tlist_{fidx}_{ttype}_count = g:tlist_{i}_{ttype}_count
        unlet! g:tlist_{i}_{ttype}_count
        let k = 1
        while k <= s:tlist_{fidx}_{ttype}_count
          let s:tlist_{fidx}_{ttype}_{k} = g:tlist_{i}_{ttype}_{k}
          unlet! g:tlist_{i}_{ttype}_{k}
          let k = k + 1
        endwhile
      else
        let s:tlist_{fidx}_{ttype} = ''
        let s:tlist_{fidx}_{ttype}_offset = 0
        let s:tlist_{fidx}_{ttype}_count = 0
      endif
    endfor
    let i = i + 1
  endwhile
  " If the taglist window is open, then update it
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    let save_winnr = winnr()
    " Goto the taglist window
    call s:WindowGotoWindow()
    " Refresh the taglist window
    call s:WindowRefresh()
    " Go back to the original window
    if save_winnr != winnr()
      call s:ExeCmdWithoutAcmds('wincmd p')
    endif
  endif
endfunction

" Save a taglist session (information about all the displayed files
" and the tags) into the specified file
function! taglist#SessionSave(...)
  if a:0 == 0 || a:1 == ''
    call s:WarningMsg('Usage: SessionSave <filename>')
    return
  endif
  let sessionfile = a:1
  if s:tlist_file_count == 0
    " There is nothing to save
    call s:WarningMsg('Taglist is empty. Nothing to save.')
    return
  endif
  if filereadable(sessionfile)
    let ans = input('Do you want to overwrite ' . sessionfile . ' (Y/N)?')
    if ans !=? 'y'
      return
    endif
    echo "\n"
  endif
  let old_verbose = &verbose
  set verbose&vim
  exe 'redir! > ' . sessionfile
  silent! echo '" Taglist session file. This file is auto-generated.'
  silent! echo '" File information'
  silent! echo 'let tlist_file_count = ' . s:tlist_file_count
  let i = 0
  while i < s:tlist_file_count
    " Store information about the file
    silent! echo 'let tlist_' . i . "_filename = '" .
          \ s:tlist_{i}_filename . "'"
    silent! echo 'let tlist_' . i . '_sort_type = "' .
          \ s:tlist_{i}_sort_type . '"'
    silent! echo 'let tlist_' . i . '_filetype = "' .
          \ s:tlist_{i}_filetype . '"'
    silent! echo 'let tlist_' . i . '_tag_count = ' .
          \ s:tlist_{i}_tag_count
    " Store information about all the tags
    let j = 1
    while j <= s:tlist_{i}_tag_count
      let txt = escape(s:tlist_{i}_{j}_tag, '"\\')
      silent! echo 'let tlist_' . i . '_' . j . '_tag = "' . txt . '"'
      silent! echo 'let tlist_' . i . '_' . j . '_tag_name = "' .
            \ s:tlist_{i}_{j}_tag_name . '"'
      silent! echo 'let tlist_' . i . '_' . j . '_ttype_idx' . ' = ' .
            \ s:tlist_{i}_{j}_ttype_idx
      let j = j + 1
    endwhile
    " Store information about all the tags grouped by their type
    let ftype = s:tlist_{i}_filetype
    for ttype in keys(s:tlist_session_settings[ftype]['flags'])
      if s:tlist_{i}_{ttype}_count != 0
        let txt = escape(s:tlist_{i}_{ttype}, '"\')
        let txt = substitute(txt, "\n", "\\\\n", 'g')
        silent! echo 'let tlist_' . i . '_' . ttype . ' = "' .
              \ txt . '"'
        silent! echo 'let tlist_' . i . '_' . ttype . '_count = ' .
              \ s:tlist_{i}_{ttype}_count
        let k = 1
        while k <= s:tlist_{i}_{ttype}_count
          silent! echo 'let tlist_' . i . '_' . ttype . '_' . k .
                \ ' = ' . s:tlist_{i}_{ttype}_{k}
          let k = k + 1
        endwhile
      endif
    endfor
    silent! echo
    let i = i + 1
  endwhile
  redir END
  let &verbose = old_verbose
endfunction

" Enable logging of taglist debug messages.
function! taglist#DebugEnable(...)
  let s:tlist_debug = 1
  " Check whether a valid file name is supplied.
  if a:1 != ''
    let s:tlist_debug_file = fnamemodify(a:1, ':p')
    " Empty the log file
    exe 'redir! > ' . s:tlist_debug_file
    redir END
    " Check whether the log file is present/created
    if !filewritable(s:tlist_debug_file)
      call s:WarningMsg('Unable to create log file '
            \ . s:tlist_debug_file)
      let s:tlist_debug_file = ''
    endif
  endif
endfunction

" Disable logging of taglist debug messages.
function! taglist#DebugDisable(...)
  let s:tlist_debug = 0
  let s:tlist_debug_file = ''
endfunction

" Display the taglist debug messages in a new window
function! taglist#DebugShow()
  if s:tlist_msg == ''
    call s:WarningMsg('No debug messages')
    return
  endif
  " Open a new window to display the taglist debug messages
  new taglist_debug.txt
  " Delete all the lines (if the buffer already exists)
  silent! %delete _
  " Add the messages
  silent! put =s:tlist_msg
  " Move the cursor to the first line
  normal! gg
endfunction

" When the mouse cursor is over a tag in the taglist window, display the
" tag prototype (balloon)
function! taglist#BallonExpr()
  " Get the file index
  let fidx = s:WindowGetFileIndexByLinenum(v:beval_lnum)
  if fidx == -1
    return ''
  endif
  " Get the tag output line for the current tag
  let tidx = s:WindowGetTagIndex(fidx, v:beval_lnum)
  if tidx == 0
    return ''
  endif
  " Get the tag search pattern and display it
  return s:GetTagPrototype(fidx, tidx)
endfunction

" Set the name of the external plugin/application to which taglist
" belongs.
" Taglist plugin is part of another plugin like cream or winmanager.
function! taglist#SetApp(name)
  if a:name == ''
    return
  endif
  let s:tlist_app_name = a:name
endfunction

" Initialization required for integration with winmanager
function! taglist#Start()
  " If current buffer is not taglist buffer, then don't proceed
  if bufname('%') != '__Tag_List__'
    return
  endif
  call taglist#SetApp('winmanager')
  " Get the current filename from the winmanager plugin
  let bufnum = WinManagerGetLastEditedFile()
  if bufnum != -1
    let filename = fnamemodify(bufname(bufnum), ':p')
    let ftype = s:GetBufferFileType(bufnum)
  endif
  " Initialize the taglist window, if it is not already initialized
  if !exists('s:tlist_window_initialized') || !s:tlist_window_initialized
    call s:WindowInit()
    call s:WindowRefresh()
    let s:tlist_window_initialized = 1
  endif
  " Update the taglist window
  if bufnum != -1
    if !s:SkipFile(filename, ftype) && g:tlist_auto_update
      call s:WindowRefreshFile(filename, ftype)
    endif
  endif
endfunction

function! taglist#IsValid()
  return 0
endfunction

function! taglist#WrapUp()
  return 0
endfunction
" }}}1

" INTERNAL FUNCTIONS: {{{1
" Display a message using WarningMsg highlight group
function! s:WarningMsg(msg)
  echohl WarningMsg
  echomsg 'TagList: ' . a:msg
  echohl None
endfunction

" Log the supplied debug message along with the time
function! s:LogMsg(msg)
  if s:tlist_debug
    let msg = strftime('%H:%M:%S') . ': ' . a:msg . "\n"
    if s:tlist_debug_file != ''
      exe 'redir >> ' . s:tlist_debug_file
      silent echon msg
      redir END
    else
      " Log the message into a variable
      " Retain only the last 3000 characters
      let len = strlen(s:tlist_msg)
      if len > 3000
        let s:tlist_msg = strpart(s:tlist_msg, len - 3000)
      endif
      let s:tlist_msg .= msg
    endif
  endif
endfunction

" Execute the specified Ex command after disabling autocommands
function! s:ExeCmdWithoutAcmds(cmd)
  let old_eventignore = &eventignore
  set eventignore=all
  exe a:cmd
  let &eventignore = old_eventignore
endfunction

" Returns 1 if a file is removed by a user from the taglist
function! s:IsRemovedFile(filename)
  return match(s:tlist_removed_flist, '^' . a:filename . '$') != -1
endfunction

" Update the list of user removed files from the taglist
" add == 1, add the file to the removed list
" add == 0, delete the file from the removed list
function! s:UpdateRemovedFileList(filename, add)
  if a:add
    call add(s:tlist_removed_flist, a:filename)
  elseif s:IsRemovedFile(a:filename)
    let idx = match(s:tlist_removed_flist, '^' . a:filename . '$')
    call remove(s:tlist_removed_flist, idx)
  endif
endfunction

" Determine the filetype for the specified file using the filetypedetect
" autocmd.
function! s:GetFileType(fname)
  " Save the 'filetype', as this will be changed temporarily
  let old_filetype = &filetype
  " Ignore the filetype autocommands
  let old_eventignore = &eventignore
  set eventignore=FileType
  " Run the filetypedetect group of autocommands to determine
  " the filetype
  exe 'doautocmd filetypedetect BufRead ' . a:fname
  " Save the detected filetype
  let ftype = &filetype
  " Restore the previous state
  let &filetype = old_filetype
  let &eventignore = old_eventignore
  return ftype
endfunction

" Get the filetype for the specified buffer
function! s:GetBufferFileType(bnum)
  let bname = bufname(a:bnum)
  " Skip non-existent buffers
  if !bufexists(bname)
    return ''
  endif
  let buf_ft = getbufvar(bname, '&filetype')
  " Check whether 'filetype' contains multiple file types separated by '.'
  " If it is, then use the first file type
  if buf_ft =~ '\.'
    let buf_ft = matchstr(buf_ft, '[^.]\+')
  endif
  if bufloaded(bname)
    " For loaded buffers, the 'filetype' is already determined
    return buf_ft
  endif
  " For unloaded buffers, if the 'filetype' option is set, return it
  if buf_ft != ''
    return buf_ft
  endif
  " For buffers whose filetype is not yet determined, try to determine
  " the filetype
  return s:GetFileType(bname)
endfunction

" Return the index of the specified filename
function! s:GetFileIndex(fname)
  if s:tlist_file_count == 0 || a:fname == ''
    return -1
  endif
  " If the new filename is same as the last accessed filename, then
  " return that index
  if s:tlist_file_name_idx_cache != -1 &&
        \ s:tlist_file_name_idx_cache < s:tlist_file_count
    if s:tlist_{s:tlist_file_name_idx_cache}_filename == a:fname
      " Same as the last accessed file
      return s:tlist_file_name_idx_cache
    endif
  endif
  " First, check whether the filename is present
  let s_fname = a:fname . "\n"
  let i = stridx(s:tlist_file_names, s_fname)
  if i == -1
    let s:tlist_file_name_idx_cache = -1
    return -1
  endif
  " Second, compute the file name index
  let nl_txt = substitute(strpart(s:tlist_file_names, 0, i), "[^\n]", '', 'g')
  let s:tlist_file_name_idx_cache = strlen(nl_txt)
  return s:tlist_file_name_idx_cache
endfunction

function! s:ParseRawSettingStrings(settings)
  " Format of the string that specifies the filetype and ctags arugments:
  "
  "       <ctags_ftype>;<flag>:<name>;<flag>:<name>;...
  "
  " Note: The file type passed to ctags may be different from the
  " file type detected by Vim
  let msg = 'Invalid ctags option setting - ' . a:settings
  let pos = stridx(a:settings, ';')
  if pos == -1
    call s:WarningMsg(msg)
    return {}
  endif
  let ftype = strpart(a:settings, 0, pos)
  " Make sure a valid filetype is supplied. If the user didn't specify a
  " valid filetype, then the ctags option settings may be treated as the
  " filetype
  if ftype == '' || ftype =~ ':'
    call s:WarningMsg(msg)
    return {}
  endif
  let parsed_settings = { 'ftype': ftype, 'flags': {} }
  " Remove the file type from settings
  let settings = strpart(a:settings, pos + 1)
  if settings == ''
    call s:WarningMsg(msg)
    return {}
  endif
  " Process all the specified ctags flags.
  while settings != ''
    " Extract the flag
    let pos = stridx(settings, ':')
    if pos == -1
      call s:WarningMsg(msg)
      return {}
    endif
    let flag = strpart(settings, 0, pos)
    if flag == ''
      call s:WarningMsg(msg)
      return {}
    endif
    " Remove the flag from settings
    let settings = strpart(settings, pos + 1)
    " Extract the tag type name
    let pos = stridx(settings, ';')
    if pos == -1
      call s:WarningMsg(msg)
      return {}
    endif
    let name = strpart(settings, 0, pos)
    if name == ''
      call s:WarningMsg(msg)
      return {}
    endif
    let settings = strpart(settings, pos + 1)
    let parsed_settings['flags'][flag] = name
  endwhile
  return parsed_settings
endfunction

" Initialize the ctags settings for the session
" with respect to the specified file type
function! s:InitFileTypeSettings(ftype)
  call s:LogMsg('InitFileTypeSettings(' . a:ftype . ')')
  if !exists('s:tlist_session_settings')
    let s:tlist_session_settings = {}
  endif
  " No need to do anything if session file type
  " settings already exist
  if has_key(s:tlist_session_settings, a:ftype)
    return 1
  endif
  " If the user didn't specify any settings, use the default
  " ctags settings. Otherwise, use the settings specified by the user.
  " This allows the user settings to overwrite the default settings.
  if exists('g:tlist_' . a:ftype . '_settings')
    " User specified ctags settings
    let settings = s:ParseRawSettingStrings(eval(
          \ 'g:tlist_' . a:ftype . '_settings'))
    if empty(settings)
      return 0
    endif
  elseif has_key(s:tlist_def_settings, a:ftype)
    " Default ctags settings
    let settings = s:ParseRawSettingStrings(s:tlist_def_settings[a:ftype])
  else
    " No default settings for this file type. This filetype is
    " not supported
    return 0
  endif
  " Store ctags settings for the session
  let s:tlist_session_settings[a:ftype] = settings
  return 1
endfunction

" Extract the tag type from the tag text
function! s:ExtractTagType(tag_line)
  " The tag type starts after the tag prototype field
  " ended with the /;"\t string, and ends before the \tline: string
  return matchstr(a:tag_line, '/;"\t\zs.\{-}\ze\tline:')
endfunction

" Extract the tag scope from the tag text
function! s:ExtractTagScope(tag_line)
  let start = strridx(a:tag_line, 'line:')
  let end   = strridx(a:tag_line, "\t")
  if end <= start
    return ''
  endif
  let tag_scope = strpart(a:tag_line, end + 1)
  let tag_scope = strpart(tag_scope, stridx(tag_scope, ':') + 1)
  return tag_scope
endfunction

" Parse a tag line from the ctags output. Separate the tag output based on the
" tag type and store it in the tag type variable.
" The format of each line in the ctags output is:
"
"     tag_name<TAB>file_name<TAB>ex_cmd;"<TAB>extension_fields
"
function! s:ParseTagLine(tag_line)
  if a:tag_line == ''
    " Skip empty lines
    return
  endif
  " Extract the tag type
  let ttype = s:ExtractTagType(a:tag_line)
  " Make sure the tag type is a valid and supported one
  if ttype == '' || stridx(s:ctags_flags, ttype) == -1
    " Line is not in proper tags format or Tag type is not supported
    return
  endif
  " Update the total tag count
  let s:tidx = s:tidx + 1
  " The following variables are used to optimize this code.  Vim is slow in
  " using curly brace names. To reduce the amount of processing needed, the
  " curly brace variables are pre-processed here
  let fidx_tidx = 's:tlist_' . s:fidx . '_' . s:tidx
  let fidx_ttype = 's:tlist_' . s:fidx . '_' . ttype
  " Update the count of this tag type
  let ttype_idx = {fidx_ttype}_count + 1
  let {fidx_ttype}_count = ttype_idx
  " Store the ctags output for this tag
  let {fidx_tidx}_tag = a:tag_line
  " Store the tag index and the tag type index (back pointers)
  let {fidx_ttype}_{ttype_idx} = s:tidx
  let {fidx_tidx}_ttype_idx = ttype_idx
  " Extract the tag name
  let tag_name = strpart(a:tag_line, 0, stridx(a:tag_line, "\t"))
  " Extract the tag scope/prototype
  if g:tlist_display_prototype
    let ttxt = '    ' . s:GetTagPrototype(s:fidx, s:tidx)
  else
    let ttxt = '    ' . tag_name
    " Add the tag scope, if it is available and is configured. Tag
    " scope is the last field after the 'line:<num>\t' field
    if g:tlist_display_tag_scope
      let tag_scope = s:GetTagScope(s:fidx, s:tidx)
      if tag_scope != ''
        let ttxt = ttxt . ' [' . tag_scope . ']'
      endif
    endif
  endif
  " Add this tag to the tag type variable
  let {fidx_ttype} = {fidx_ttype} . ttxt . "\n"
  " Save the tag name
  let {fidx_tidx}_tag_name = tag_name
endfunction

" Return the tag type for the specified tag index
function! s:GetTagTypeByTag(fidx, tidx)
  let ttype_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_type'
  " Already parsed and have the tag name
  if exists(ttype_var)
    return {ttype_var}
  endif
  let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
  let {ttype_var} = s:ExtractTagType(tag_line)
  return {ttype_var}
endfunction

function! s:GetTagPrototype(fidx, tidx)
  let tproto_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_proto'
  " Already parsed and have the tag prototype
  if exists(tproto_var)
    return {tproto_var}
  endif
  " Parse and extract the tag prototype
  let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
  let start = stridx(tag_line, '/^') + 2
  let end = stridx(tag_line, '/;"' . "\t")
  if tag_line[end - 1] == '$'
    let end = end -1
  endif
  let tag_proto = strpart(tag_line, start, end - start)
  let {tproto_var} = substitute(tag_proto, '\s*', '', '')
  return {tproto_var}
endfunction

" Get the scope (e.g. C++ class) of a tag
" Tag scope is the last field after the 'line:<num>\t' field
function! s:GetTagScope(fidx, tidx)
  let tscope_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_scope'
  " Already parsed and have the tag scope
  if exists(tscope_var)
    return {tscope_var}
  endif
  " Parse and extract the tag scope
  let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
  let {tscope_var} = s:ExtractTagScope(tag_line)
  return {tscope_var}
endfunction

function! s:GetTagSearchPat(fidx, tidx)
  let tpat_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_searchpat'
  " Already parsed and have the tag search pattern
  if exists(tpat_var)
    return {tpat_var}
  endif
  " Parse and extract the tag search pattern
  let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
  let start = stridx(tag_line, '/^') + 2
  let end = stridx(tag_line, '/;"' . "\t")
  if tag_line[end - 1] == '$'
    let end = end -1
  endif
  let {tpat_var} = '\V\^' . strpart(tag_line, start, end - start) .
        \ (tag_line[end] == '$' ? '\$' : '')
  return {tpat_var}
endfunction

" Return the tag line number, given the tag index
function! s:GetTagLinenum(fidx, tidx)
  let tline_var = 's:tlist_' . a:fidx . '_' . a:tidx . '_tag_linenum'
  " Already parsed and have the tag line number
  if exists(tline_var)
    return {tline_var}
  endif
  " Parse and extract the tag line number
  let tag_line = s:tlist_{a:fidx}_{a:tidx}_tag
  let start = strridx(tag_line, 'line:') + 5
  let end = strridx(tag_line, "\t")
  if end < start
    let {tline_var} = strpart(tag_line, start) + 0
  else
    let {tline_var} = strpart(tag_line, start, end - start) + 0
  endif
  return {tline_var}
endfunction

" Check whether tag listing is supported for the specified file
function! s:SkipFile(filename, ftype)
  " Skip buffers with no names and buffers with filetype not set
  if a:filename == '' || a:ftype == ''
    return 1
  endif
  " Skip files which are not supported by exuberant ctags
  " First check whether default settings for this filetype are available.
  " If it is not available, then check whether user specified settings are
  " available. If both are not available, then don't list the tags for this
  " filetype
  if !has_key(s:tlist_def_settings, a:ftype) &&
        \ !exists('g:tlist_' . a:ftype . '_settings') 
    return 1
  endif
  " Skip files which are not readable or files which are not yet stored
  " to the disk
  if !filereadable(a:filename)
    return 1
  endif
  return 0
endfunction

" Initialize the variables for a new file
function! s:InitFile(filename, ftype)
  call s:LogMsg('InitFile(' . a:filename . ')')
"   if !has_key(s:tlist_file_dict, a:filename)
"     let s:tlist_file_dict[a:filename] = {
"           \ 'file_type' : a:ftype,
"           \ 'sort_type' : g:tlist_sort_type,
"           \ 'mtime'     : -1,
"           \ 'start'     : 0,
"           \ 'end'       : 0,
"           \ 'valid'     : 0,
"           \ 'tag_count' : 0,
"           \ 'menu_cmd'  : '',
"           \ }
"   endif
  " Add new files at the end of the list
  let fidx = s:tlist_file_count
  let s:tlist_file_count = s:tlist_file_count + 1
  " Add the new file name to the taglist list of file names
  let s:tlist_file_names = s:tlist_file_names . a:filename . "\n"
  " Initialize the file variables
  let s:tlist_{fidx}_filename = a:filename
  let s:tlist_{fidx}_sort_type = g:tlist_sort_type
  let s:tlist_{fidx}_filetype = a:ftype
  let s:tlist_{fidx}_mtime = -1
  let s:tlist_{fidx}_start = 0
  let s:tlist_{fidx}_end = 0
  let s:tlist_{fidx}_valid = 0
  let s:tlist_{fidx}_visible = 0
  let s:tlist_{fidx}_tag_count = 0
  let s:tlist_{fidx}_menu_cmd = ''
  " Initialize the tag type variables
  for ttype in keys(s:tlist_session_settings[a:ftype]['flags'])
    let s:tlist_{fidx}_{ttype} = ''
    let s:tlist_{fidx}_{ttype}_offset = 0
    let s:tlist_{fidx}_{ttype}_count = 0
  endfor
  return fidx
endfunction

" Get the list of tags defined in the specified file and store them
" in Vim variables. Returns the file index where the tags are stored.
function! s:ProcessFile(filename, ftype)
  call s:LogMsg('ProcessFile(' . a:filename . ', ' . a:ftype . ')')
  " Check whether this file is supported
  if s:SkipFile(a:filename, a:ftype)
    return -1
  endif
  " If the tag types for this filetype are not yet created, then create
  " them now
  if !exists('s:tlist_session_settings[a:ftype]')
    if s:InitFileTypeSettings(a:ftype) == 0
      return -1
    endif
  endif
  " If this file is already processed, then use the cached values
  let fidx = s:GetFileIndex(a:filename)
  if fidx == -1
    " First time, this file is loaded
    let fidx = s:InitFile(a:filename, a:ftype)
  else
    " File was previously processed. Discard the tag information
    call s:DiscardTagInfo(fidx)
  endif
  let s:tlist_{fidx}_valid = 1
  " Create ctags arguments
  let ctags_args = ''
  " Read contents of ctags configuration file
  if exists('g:tlist_ctags_conf') && len(g:tlist_ctags_conf) > 0
    for ctags_conf_lines in readfile(g:tlist_ctags_conf)
      let ctags_args .= len(ctags_conf_lines) > 0 ? ' ' . ctags_conf_lines : ''
    endfor
  endif
  " Default ctags arguments for taglist plugin
  let ctags_args .= ' -f - --format=2 --excmd=pattern --fields=nks'
  " Add sort type to ctags arguments
  let ctags_args .= ' ' . (s:tlist_{fidx}_sort_type == 'name' ?
        \ '--sort=yes' :
        \ '--sort=no')
  " Add the filetype specific arguments
  let ctags_args .= ' --language-force=' . s:tlist_session_settings[a:ftype]['ftype'] .
        \ ' --' . s:tlist_session_settings[a:ftype]['ftype'] . '-types=' .
        \ join(keys(s:tlist_session_settings[a:ftype]['flags']), '')
  " Ctags command to produce output with regexp for locating the tags
  let ctags_cmd = g:tlist_ctags_cmd . ' ' . ctags_args . ' "' . a:filename . '"'

  if &shellxquote == '"'
    " Double-quotes within double-quotes will not work in the
    " command-line.If the 'shellxquote' option is set to double-quotes,
    " then escape the double-quotes in the ctags command-line.
    let ctags_cmd = escape(ctags_cmd, '"')
  endif
  " In Windows 95, if not using cygwin, disable the 'shellslash'
  " option. Otherwise, this will cause problems when running the
  " ctags command.
  if has('win95') && !has('win32unix')
    let old_shellslash = &shellslash
    set noshellslash
  endif
  if has('win32') && !has('win32unix') && !has('win95')
        \ && (&shell =~ 'cmd.exe')
    " Windows does not correctly deal with commands that have more than 1
    " set of double quotes.  It will strip them all resulting in:
    " 'C:\Program' is not recognized as an internal or external command
    " operable program or batch file.  To work around this, place the
    " command inside a batch file and call the batch file.
    " Do this only on Win2K, WinXP and above.
    " Contributed by: David Fishburn.
    let s:taglist_tempfile = fnamemodify(tempname(), ':h') .
          \ '\taglist.cmd'
    call writefile([ctags_cmd], s:taglist_tempfile, 'b')
    call s:LogMsg('Cmd inside batch file: ' . ctags_cmd)
    let ctags_cmd = '"' . s:taglist_tempfile . '"'
  endif

  call s:LogMsg('Cmd: ' . ctags_cmd)
  " Run ctags and get the tag list
  let cmd_output = system(ctags_cmd)
  " Restore the value of the 'shellslash' option.
  if has('win95') && !has('win32unix')
    let &shellslash = old_shellslash
  endif
  if exists('s:taglist_tempfile')
    " Delete the temporary cmd file created on MS-Windows
    call delete(s:taglist_tempfile)
  endif
  " Handle errors
  if v:shell_error
    let msg = "Taglist: Failed to generate tags for " . a:filename
    call s:WarningMsg(msg)
    if cmd_output != ''
      call s:WarningMsg(cmd_output)
    endif
    return fidx
  endif
  " Store the modification time for the file
  let s:tlist_{fidx}_mtime = getftime(a:filename)
  " No tags for current file
  if cmd_output == ''
    call s:LogMsg('No tags defined in ' . a:filename)
    return fidx
  endif
  call s:LogMsg('Generated tags information for ' . a:filename)
  " The following script local variables are used by the
  " ParseTagLine() function.
  let s:ctags_flags = join(keys(s:tlist_session_settings[a:ftype]['flags']), '')
  let s:fidx = fidx
  let s:tidx = 0
  " Process the ctags output one line at a time.  The substitute()
  " command is used to parse the tag lines instead of using the
  " matchstr()/stridx()/strpart() functions for performance reason
  call substitute(cmd_output, "\\([^\n]\\+\\)\n",
        \ '\=s:ParseTagLine(submatch(1))', 'g')
  " Save the number of tags for this file
  let s:tlist_{fidx}_tag_count = s:tidx
  " The following script local variables are no longer needed
  unlet! s:ctags_flags
  unlet! s:tidx
  unlet! s:fidx
  call s:LogMsg('Processed ' . s:tlist_{fidx}_tag_count .
        \ ' tags in ' . a:filename)
  return fidx
endfunction

" Update the tags for a file (if needed)
function! UpdateFile(filename, ftype)
  call s:LogMsg('UpdateFile(' . a:filename . ')')
  " If the file doesn't support tag listing, skip it
  if s:SkipFile(a:filename, a:ftype)
    return
  endif
  " Convert the file name to a full path
  let fname = fnamemodify(a:filename, ':p')
  " First check whether the file already exists
  let fidx = s:GetFileIndex(fname)
  if fidx != -1 && s:tlist_{fidx}_valid
    " File exists and the tags are valid
    " Check whether the file was modified after the last tags update
    " If it is modified, then update the tags
    if s:tlist_{fidx}_mtime == getftime(fname)
      return
    endif
  else
    " If the tags were removed previously based on a user request,
    " as we are going to update the tags (based on the user request),
    " remove the filename from the deleted list
    call s:UpdateRemovedFileList(fname, 0)
  endif
  " If the taglist window is opened, update it
  let winnum = bufwinnr(g:TagList_title)
  if winnum == -1
    " Taglist window is not present. Just update the taglist
    " and return
    call s:ProcessFile(fname, a:ftype)
  else
    if g:tlist_show_one_file && s:tlist_cur_file_idx != -1
      " If tags for only one file are displayed and we are not
      " updating the tags for that file, then no need to
      " refresh the taglist window. Otherwise, the taglist
      " window should be updated.
      if s:tlist_{s:tlist_cur_file_idx}_filename != fname
        call s:ProcessFile(fname, a:ftype)
        return
      endif
    endif
    " Save the current window number
    let save_winnr = winnr()
    " Goto the taglist window
    call s:WindowGotoWindow()
    " Save the cursor position
    let save_line = line('.')
    let save_col = col('.')
    " Update the taglist window
    call s:WindowRefreshFile(fname, a:ftype)
    " Restore the cursor position
    if v:version >= 601
      call cursor(save_line, save_col)
    else
      exe save_line
      exe 'normal! ' . save_col . '|'
    endif
    if winnr() != save_winnr
      " Go back to the original window
      call s:ExeCmdWithoutAcmds(save_winnr . 'wincmd w')
    endif
  endif
  " Update the taglist menu
  if g:tlist_show_menu
    call s:MenuUpdateFile(1)
  endif
endfunction

" Discard the stored tag information for a file
function! s:DiscardTagInfo(fidx)
  call s:LogMsg('DiscardTagInfo(' . s:tlist_{a:fidx}_filename . ')')
  let ftype = s:tlist_{a:fidx}_filetype
  " Discard information about the tags defined in the file
  let i = 1
  while i <= s:tlist_{a:fidx}_tag_count
    let fidx_i = 's:tlist_' . a:fidx . '_' . i
    unlet! {fidx_i}_tag
    unlet! {fidx_i}_tag_name
    unlet! {fidx_i}_tag_type
    unlet! {fidx_i}_ttype_idx
    unlet! {fidx_i}_tag_proto
    unlet! {fidx_i}_tag_scope
    unlet! {fidx_i}_tag_searchpat
    unlet! {fidx_i}_tag_linenum
    let i = i + 1
  endwhile
  let s:tlist_{a:fidx}_tag_count = 0
  " Discard information about tag type groups
  for ttype in keys(s:tlist_session_settings[ftype]['flags'])
    if s:tlist_{a:fidx}_{ttype} != ''
      let fidx_ttype = 's:tlist_' . a:fidx . '_' . ttype
      let {fidx_ttype} = ''
      let {fidx_ttype}_offset = 0
      let cnt = {fidx_ttype}_count
      let {fidx_ttype}_count = 0
      let j = 1
      while j <= cnt
        unlet! {fidx_ttype}_{j}
        let j = j + 1
      endwhile
    endif
  endfor
  " Discard the stored menu command also
  let s:tlist_{a:fidx}_menu_cmd = ''
endfunction

" Discard the stored information for a file
function! s:DiscardFileInfo(fidx)
  call s:LogMsg('DiscardFileInfo(' . s:tlist_{a:fidx}_filename . ')')
  call s:DiscardTagInfo(a:fidx)
  let ftype = s:tlist_{a:fidx}_filetype
  for ttype in keys(s:tlist_session_settings[ftype]['flags'])
    unlet! s:tlist_{a:fidx}_{ttype}
    unlet! s:tlist_{a:fidx}_{ttype}_offset
    unlet! s:tlist_{a:fidx}_{ttype}_count
  endfor
  unlet! s:tlist_{a:fidx}_filename
  unlet! s:tlist_{a:fidx}_sort_type
  unlet! s:tlist_{a:fidx}_filetype
  unlet! s:tlist_{a:fidx}_mtime
  unlet! s:tlist_{a:fidx}_start
  unlet! s:tlist_{a:fidx}_end
  unlet! s:tlist_{a:fidx}_valid
  unlet! s:tlist_{a:fidx}_visible
  unlet! s:tlist_{a:fidx}_tag_count
  unlet! s:tlist_{a:fidx}_menu_cmd
endfunction

" Remove the file under the cursor or the specified file index
" user_request - User requested to remove the file from taglist
function! s:RemoveFile(fidx, user_request)
  let fidx = a:fidx
  if fidx == -1
    let fidx = s:WindowGetFileIndexByLinenum(line('.'))
    if fidx == -1
      return
    endif
  endif
  call s:LogMsg('RemoveFile(' .
        \ s:tlist_{fidx}_filename . ', ' . a:user_request . ')')
  let cur_winnr = winnr()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    " Taglist window is open, remove the file from display
    if cur_winnr != tlist_winnr
      call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
    endif
    call s:WindowRemoveFileFromDisplay(fidx)
    if cur_winnr != tlist_winnr
      call s:ExeCmdWithoutAcmds('wincmd p')
    endif
  endif
  let fname = s:tlist_{fidx}_filename
  if a:user_request
    " As the user requested to remove the file from taglist,
    " add it to the removed list
    call s:UpdateRemovedFileList(fname, 1)
  endif
  " Remove the file name from the taglist list of filenames
  let idx = stridx(s:tlist_file_names, fname . "\n")
  let text_before = strpart(s:tlist_file_names, 0, idx)
  let rem_text = strpart(s:tlist_file_names, idx)
  let next_idx = stridx(rem_text, "\n")
  let text_after = strpart(rem_text, next_idx + 1)
  let s:tlist_file_names = text_before . text_after
  call s:DiscardFileInfo(fidx)
  " Shift all the file variables by one index
  let i = fidx + 1
  while i < s:tlist_file_count
    let j = i - 1
    let s:tlist_{j}_filename = s:tlist_{i}_filename
    let s:tlist_{j}_sort_type = s:tlist_{i}_sort_type
    let s:tlist_{j}_filetype = s:tlist_{i}_filetype
    let s:tlist_{j}_mtime = s:tlist_{i}_mtime
    let s:tlist_{j}_start = s:tlist_{i}_start
    let s:tlist_{j}_end = s:tlist_{i}_end
    let s:tlist_{j}_valid = s:tlist_{i}_valid
    let s:tlist_{j}_visible = s:tlist_{i}_visible
    let s:tlist_{j}_tag_count = s:tlist_{i}_tag_count
    let s:tlist_{j}_menu_cmd = s:tlist_{i}_menu_cmd
    let k = 1
    while k <= s:tlist_{j}_tag_count
      let s:tlist_{j}_{k}_tag = s:tlist_{i}_{k}_tag
      let s:tlist_{j}_{k}_tag_name = s:tlist_{i}_{k}_tag_name
      let s:tlist_{j}_{k}_tag_type = s:Tlist_Get_Tag_Type_By_Tag(i, k)
      let s:tlist_{j}_{k}_ttype_idx = s:tlist_{i}_{k}_ttype_idx
      let s:tlist_{j}_{k}_tag_proto = s:Tlist_Get_Tag_Prototype(i, k)
      let s:tlist_{j}_{k}_tag_scope = s:Tlist_Get_Tag_Scope(i, k)
      let s:tlist_{j}_{k}_tag_searchpat = s:Tlist_Get_Tag_SearchPat(i, k)
      let s:tlist_{j}_{k}_tag_linenum = s:Tlist_Get_Tag_Linenum(i, k)
      let k = k + 1
    endwhile
    let ftype = s:tlist_{i}_filetype
    for ttype in keys(s:tlist_session_settings[ftype]['flags'])
      let s:tlist_{j}_{ttype} = s:tlist_{i}_{ttype}
      let s:tlist_{j}_{ttype}_offset = s:tlist_{i}_{ttype}_offset
      let s:tlist_{j}_{ttype}_count = s:tlist_{i}_{ttype}_count
      if s:tlist_{j}_{ttype} != ''
        let l = 1
        while l <= s:tlist_{j}_{ttype}_count
          let s:tlist_{j}_{ttype}_{l} = s:tlist_{i}_{ttype}_{l}
          let l = l + 1
        endwhile
      endif
    endfor
    " As the file and tag information is copied to the new index,
    " discard the previous information
    call s:DiscardFileInfo(i)
    let i = i + 1
  endwhile
  " Reduce the number of files displayed
  let s:tlist_file_count = s:tlist_file_count - 1
  if g:tlist_show_one_file
    " If the tags for only one file is displayed and if we just
    " now removed that file, then invalidate the current file idx
    if s:tlist_cur_file_idx == fidx
      let s:tlist_cur_file_idx = -1
    endif
  endif
endfunction

" Process multiple files. Each filename is separated by "\n"
" Returns the number of processed files
function! s:ProcessFilelist(file_names)
  let flist = a:file_names
  " Enable lazy screen updates
  let old_lazyredraw = &lazyredraw
  set lazyredraw
  " Keep track of the number of processed files
  let fcnt = 0
  " Process one file at a time
  while flist != ''
    let nl_idx = stridx(flist, "\n")
    let one_file = strpart(flist, 0, nl_idx)
    " Remove the filename from the list
    let flist = strpart(flist, nl_idx + 1)
    if one_file == ''
      continue
    endif
    " Skip directories
    if isdirectory(one_file)
      continue
    endif
    let ftype = s:DetectFiletype(one_file)
    echon "\r                                                              "
    echon "\rProcessing tags for " . fnamemodify(one_file, ':p:t')
    let fcnt = fcnt + 1
    call UpdateFile(one_file, ftype)
  endwhile
  " Clear the displayed informational messages
  echon "\r                                                            "
  " Restore the previous state
  let &lazyredraw = old_lazyredraw
  return fcnt
endfunction

" Process the files in a directory matching the specified pattern
function! s:ProcessDir(dir_name, pat)
  let flist = glob(a:dir_name . '/' . a:pat) . "\n"
  let fcnt = s:ProcessFilelist(flist)
  let len = strlen(a:dir_name)
  if a:dir_name[len - 1] == '\' || a:dir_name[len - 1] == '/'
    let glob_expr = a:dir_name . '*'
  else
    let glob_expr = a:dir_name . '/*'
  endif
  let all_files = glob(glob_expr) . "\n"
  while all_files != ''
    let nl_idx = stridx(all_files, "\n")
    let one_file = strpart(all_files, 0, nl_idx)
    let all_files = strpart(all_files, nl_idx + 1)
    if one_file == ''
      continue
    endif
    " Skip non-directory names
    if !isdirectory(one_file)
      continue
    endif
    echon "\r                                                              "
    echon "\rProcessing files in directory " . fnamemodify(one_file, ':t')
    let fcnt = fcnt + s:ProcessDir(one_file, a:pat)
  endwhile
  return fcnt
endfunction

" Return the index of the filename present in the specified line number
" Line number refers to the line number in the taglist window
function! s:WindowGetFileIndexByLinenum(lnum)
  call s:LogMsg('WindowGetFileIndexByLinenum(' . a:lnum . ')')
  " First try to see whether the new line number is within the range
  " of the last returned file
  if s:tlist_file_lnum_idx_cache != -1 &&
        \ s:tlist_file_lnum_idx_cache < s:tlist_file_count
    if a:lnum >= s:tlist_{s:tlist_file_lnum_idx_cache}_start &&
          \ a:lnum <= s:tlist_{s:tlist_file_lnum_idx_cache}_end
      return s:tlist_file_lnum_idx_cache
    endif
  endif
  let fidx = -1
  if g:tlist_show_one_file
    " Displaying only one file in the taglist window. Check whether
    " the line is within the tags displayed for that file
    if s:tlist_cur_file_idx != -1
      if a:lnum >= s:tlist_{s:tlist_cur_file_idx}_start
            \ && a:lnum <= s:tlist_{s:tlist_cur_file_idx}_end
        let fidx = s:tlist_cur_file_idx
      endif
    endif
  else
    " Do a binary search in the taglist
    let left = 0
    let right = s:tlist_file_count - 1
    while left < right
      let mid = (left + right) / 2
      if a:lnum >= s:tlist_{mid}_start && a:lnum <= s:tlist_{mid}_end
        let s:tlist_file_lnum_idx_cache = mid
        return mid
      endif
      if a:lnum < s:tlist_{mid}_start
        let right = mid - 1
      else
        let left = mid + 1
      endif
    endwhile
    if left >= 0 && left < s:tlist_file_count
          \ && a:lnum >= s:tlist_{left}_start
          \ && a:lnum <= s:tlist_{left}_end
      let fidx = left
    endif
  endif
  let s:tlist_file_lnum_idx_cache = fidx
  return fidx
endfunction

" Return the tag type index for the specified line in the taglist window
function! s:WindowGetTagTypeByLinenum(fidx, lnum)
  let ftype = s:tlist_{a:fidx}_filetype
  " Determine to which tag type the current line number belongs to using the
  " tag type start line number and the number of tags in a tag type
  for ttype in keys(s:tlist_session_settings[ftype]['flags'])
    let start_lnum =
          \ s:tlist_{a:fidx}_start + s:tlist_{a:fidx}_{ttype}_offset
    let end =  start_lnum + s:tlist_{a:fidx}_{ttype}_count
    if a:lnum >= start_lnum && a:lnum <= end
      return ttype
    endif
  endfor
  return ''
endfunction

" Return the tag index for the specified line in the taglist window
function! s:WindowGetTagIndex(fidx, lnum)
  let ttype = s:WindowGetTagTypeByLinenum(a:fidx, a:lnum)
  " Current line doesn't belong to any of the displayed tag types
  if ttype == ''
    return 0
  endif
  " Compute the index into the displayed tags for the tag type
  let ttype_lnum = s:tlist_{a:fidx}_start + s:tlist_{a:fidx}_{ttype}_offset
  let tidx = a:lnum - ttype_lnum
  if tidx == 0
    return 0
  endif
  " Get the corresponding tag line and return it
  return s:tlist_{a:fidx}_{ttype}_{tidx}
endfunction

" Update the line offsets for tags for files starting from start_idx
" and displayed in the taglist window by the specified offset
function! s:WindowUpdateLineOffsets(start_idx, increment, offset)
  let i = a:start_idx
  while i < s:tlist_file_count
    if s:tlist_{i}_visible
      " Update the start/end line number only if the file is visible
      if a:increment
        let s:tlist_{i}_start = s:tlist_{i}_start + a:offset
        let s:tlist_{i}_end = s:tlist_{i}_end + a:offset
      else
        let s:tlist_{i}_start = s:tlist_{i}_start - a:offset
        let s:tlist_{i}_end = s:tlist_{i}_end - a:offset
      endif
    endif
    let i += 1
  endwhile
endfunction

" Remove the specified file from display
function! s:WindowRemoveFileFromDisplay(fidx)
  call s:LogMsg('WindowRemoveFileFromDisplay (' . s:tlist_{a:fidx}_filename . ')')
  " If the file is not visible then no need to remove it
  if !s:tlist_{a:fidx}_visible
    return
  endif
  " Remove the tags displayed for the specified file from the window
  let start = s:tlist_{a:fidx}_start
  " Include the empty line after the last line also
  let end = g:tlist_compact_format ? s:tlist_{a:fidx}_end : s:tlist_{a:fidx}_end + 1
  setlocal modifiable
  exe 'silent! ' . start . ',' . end . 'delete _'
  setlocal nomodifiable
  " Correct the start and end line offsets for all the files following
  " this file, as the tags for this file are removed
  call s:WindowUpdateLineOffsets(a:fidx + 1, 0, end - start + 1)
endfunction

" Goto the taglist window
function! s:WindowGotoWindow()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    if winnr() != tlist_winnr
      call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
    endif
  endif
endfunction

function! s:WindowDisplayHelp()
  if s:tlist_app_name == "winmanager"
    " To handle a bug in the winmanager plugin, add a space at the
    " last line
    call setline('$', ' ')
  endif
  if s:tlist_brief_help
    " Add the brief help
    call append( 0, '" Press <F1> to display help text')
  else
    " Add the extensive help
    call append( 0, '" <enter> : Jump to tag definition')
    call append( 1, '" o : Jump to tag definition in new window')
    call append( 2, '" p : Preview the tag definition')
    call append( 3, '" <space> : Display tag prototype')
    call append( 4, '" u : Update tag list')
    call append( 5, '" s : Select sort field')
    call append( 6, '" d : Remove file from taglist')
    call append( 7, '" x : Zoom-out/Zoom-in taglist window')
    call append( 8, '" + : Open a fold')
    call append( 9, '" - : Close a fold')
    call append(10, '" * : Open all folds')
    call append(11, '" = : Close all folds')
    call append(12, '" [[ : Move to the start of previous file')
    call append(13, '" ]] : Move to the start of next file')
    call append(14, '" q : Close the taglist window')
    call append(15, '" <F1> : Remove help text')
  endif
endfunction

" Toggle taglist plugin help text between the full version
" and the brief version
function! s:WindowToggleHelpText()
  if g:tlist_compact_format
    " In compact display mode, do not display help
    return
  endif
  setlocal modifiable
  " Include the empty line displayed after the help text
  let brief_help_size = 1
  let full_help_size = 16
  " Set report option to a huge value to prevent informational messages
  " while deleting the lines
  let old_report = &report
  set report=99999
  " Remove the currently highlighted tag. Otherwise, the help text
  " might be highlighted by mistake
  match none
  " Toggle between brief and full help text
  if s:tlist_brief_help
    let s:tlist_brief_help = 0
    " Remove the previous help
    exe '1,' . brief_help_size . ' delete _'
    " Adjust the start/end line numbers for the files
    call s:WindowUpdateLineOffsets(0, 1, full_help_size - brief_help_size)
  else
    let s:tlist_brief_help = 1
    " Remove the previous help
    exe '1,' . full_help_size . ' delete _'
    " Adjust the start/end line numbers for the files
    call s:WindowUpdateLineOffsets(0, 0, full_help_size - brief_help_size)
  endif
  call s:WindowDisplayHelp()
  " Restore the report option
  let &report = old_report
  setlocal nomodifiable
endfunction

" Zoom (maximize/minimize) the taglist window
function! s:WindowZoom()
  if s:tlist_win_maximized
    " Restore the window back to the previous size
    if g:tlist_use_horiz_window
      exe 'resize ' . g:tlist_win_height
    else
      exe 'vert resize ' . g:tlist_win_width
    endif
    let s:tlist_win_maximized = 0
  else
    " Set the window size to the maximum possible without closing other
    " windows
    if g:tlist_use_horiz_window
      resize
    else
      vert resize
    endif
    let s:tlist_win_maximized = 1
  endif
endfunction

" Check the width of the taglist window. For horizontally split windows, the
" 'winfixheight' option is used to fix the height of the window. For
" vertically split windows, Vim doesn't support the 'winfixwidth' option. So
" need to handle window width changes from this function.
function! s:WindowCheckWidth()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    return
  endif
  let width = winwidth(tlist_winnr)
  if width != g:tlist_win_width
    call s:LogMsg('WindowCheckWidth: Changing window width from ' .
          \ width . ' to ' . g:tlist_win_width)
    let cur_winnr = winnr()
    if cur_winnr != tlist_winnr
      call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
    endif
    exe 'vert resize ' . g:tlist_win_width
    if cur_winnr != tlist_winnr
      call s:ExeCmdWithoutAcmds('wincmd p')
    endif
  endif
endfunction

" If the 'tlist_exit_onlywindow' option is set, then exit Vim if only the
" taglist window is present.
function! s:WindowExitOnlyWindow()
  " Before quitting Vim, delete the taglist buffer so that
  " the '0 mark is correctly set to the previous buffer.
  if v:version < 700
    if winbufnr(2) == -1
      bdelete
      quit
    endif
  else
    if winbufnr(2) == -1
      if tabpagenr('$') == 1
        " Only one tag page is present
        "
        " When deleting the taglist buffer, autocommands cannot be
        " disabled. If autocommands are disabled, then on exiting Vim,
        " the window size will not be restored back to the original
        " size.
        bdelete
        quit
      else
        " More than one tab page is present. Close only the current
        " tab page
        close
      endif
    endif
  endif
endfunction

" Create a new taglist window. If it is already open, jump to it
function! s:WindowCreate()
  call s:LogMsg('WindowCreate()')
  " If the window is open, jump to it
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    " Jump to the existing window
    if winnr() != tlist_winnr
      exe tlist_winnr . 'wincmd w'
    endif
    return
  endif
  " If used with winmanager don't open windows. Winmanager will handle
  " the window/buffer management
  if s:tlist_app_name == "winmanager"
    return
  endif
  " Create a new window. If user prefers a horizontal window, then open
  " a horizontally split window. Otherwise open a vertically split
  " window
  if g:tlist_use_horiz_window
    " Open a horizontally split window
    let win_dir = 'botright'
    " Horizontal window height
    let win_size = g:tlist_win_height
  else
    if s:tlist_winsize_chgd == -1
      " Open a vertically split window. Increase the window size, if
      " needed, to accomodate the new window
      if g:tlist_inc_win_width &&
            \ &columns < (80 + g:tlist_win_width)
        " Save the original window position
        let s:tlist_pre_winx = getwinposx()
        let s:tlist_pre_winy = getwinposy()
        " one extra column is needed to include the vertical split
        let &columns= &columns + g:tlist_win_width + 1
        let s:tlist_winsize_chgd = 1
      else
        let s:tlist_winsize_chgd = 0
      endif
    endif
    if g:tlist_use_right_window
      " Open the window at the rightmost place
      let win_dir = 'botright vertical'
    else
      " Open the window at the leftmost place
      let win_dir = 'topleft vertical'
    endif
    let win_size = g:tlist_win_width
  endif
  " If the tag listing temporary buffer already exists, then reuse it.
  " Otherwise create a new buffer
  let bufnum = bufnr(g:TagList_title)
  if bufnum == -1
    " Create a new buffer
    let wcmd = g:TagList_title
  else
    " Edit the existing buffer
    let wcmd = '+buffer' . bufnum
  endif
  " Create the taglist window
  " Preserve the alternate file
  let cmd_mod = (v:version >= 700) ? 'keepalt ' : ''
  exe 'silent! ' . cmd_mod . win_dir . ' ' . win_size . 'split ' . wcmd
  " Save the new window position
  let s:tlist_winx = getwinposx()
  let s:tlist_winy = getwinposy()
  " Initialize the taglist window
  call s:WindowInit()
endfunction

" Set the default options for the taglist window
function! s:WindowInit()
  call s:LogMsg('WindowInit()')
  " The 'readonly' option should not be set for the taglist buffer.
  " If Vim is started as "view/gview" or if the ":view" command is
  " used, then the 'readonly' option is set for all the buffers.
  " Unset it for the taglist buffer
  setlocal noreadonly
  " Set the taglist buffer filetype to taglist
  setlocal filetype=taglist

  " Folding related settings
  setlocal foldenable
  setlocal foldminlines=0
  setlocal foldmethod=manual
  setlocal foldlevel=9999
  if g:tlist_enable_fold_column
    setlocal foldcolumn=3
  else
    setlocal foldcolumn=0
  endif
  setlocal foldtext=v:folddashes.getline(v:foldstart)

  if s:tlist_app_name != 'winmanager'
    " Mark buffer as scratch
    silent! setlocal buftype=nofile
    if s:tlist_app_name == 'none'
      silent! setlocal bufhidden=delete
    endif
    silent! setlocal noswapfile
    " Due to a bug in Vim 6.0, the winbufnr() function fails for unlisted
    " buffers. So if the taglist buffer is unlisted, multiple taglist
    " windows will be opened. This bug is fixed in Vim 6.1 and above
    if v:version >= 601
      silent! setlocal nobuflisted
    endif
  endif

  silent! setlocal nowrap
  " If the 'number' option is set in the source window, it will affect the
  " taglist window. So forcefully disable 'number' option for the taglist
  " window
  silent! setlocal nonumber
  if exists('&relativenumber')
    silent! setlocal norelativenumber
  endif
  " Use fixed height when horizontally split window is used
  if g:tlist_use_horiz_window
    if v:version >= 602
      set winfixheight
    endif
  else
    if v:version >= 700
      set winfixwidth
    endif
  endif
  " Setup balloon evaluation to display tag prototype
  if v:version >= 700 && has('balloon_eval')
    setlocal balloonexpr=taglist#BallonExpr()
    set ballooneval
  endif

  " Create buffer local mappings for jumping to the tags and sorting the list
  nnoremap <buffer> <silent> <CR>          :call <SID>WindowJumpToTag('useopen')<CR>
  nnoremap <buffer> <silent> o             :call <SID>WindowJumpToTag('newwin')<CR>
  nnoremap <buffer> <silent> p             :call <SID>WindowJumpToTag('preview')<CR>
  nnoremap <buffer> <silent> P             :call <SID>WindowJumpToTag('prevwin')<CR>
  if v:version >= 700
    nnoremap <buffer> <silent> t           :call <SID>WindowJumpToTag('checktab')<CR>
    nnoremap <buffer> <silent> <C-t>       :call <SID>WindowJumpToTag('newtab')<CR>
  endif
  nnoremap <buffer> <silent> <2-LeftMouse> :call <SID>WindowJumpToTag('useopen')<CR>
  nnoremap <buffer> <silent> s             :call <SID>ChangeSort('cmd', 'toggle', '')<CR>
  nnoremap <buffer> <silent> u             :call <SID>WindowUpdateFile()<CR>
  nnoremap <buffer> <silent> d             :call <SID>RemoveFile(-1, 1)<CR>
  nnoremap <buffer> <silent> x             :call <SID>WindowZoom()<CR>
  nnoremap <buffer> <silent> [[            :call <SID>WindowMoveToFile(-1)<CR>
  nnoremap <buffer> <silent> <BS>          :call <SID>WindowMoveToFile(-1)<CR>
  nnoremap <buffer> <silent> ]]            :call <SID>WindowMoveToFile(1)<CR>
  nnoremap <buffer> <silent> <Tab>         :call <SID>WindowMoveToFile(1)<CR>
  nnoremap <buffer> <silent> <Space>       :call <SID>WindowShowInfo()<CR>
  nnoremap <buffer> <silent> <F1>          :call <SID>WindowToggleHelpText()<CR>
  nnoremap <buffer> <silent> +             :silent! foldopen<CR>
  nnoremap <buffer> <silent> -             :silent! foldclose<CR>
  nnoremap <buffer> <silent> *             :silent! %foldopen!<CR>
  nnoremap <buffer> <silent> =             :silent! %foldclose<CR>
  nnoremap <buffer> <silent> <kPlus>       :silent! foldopen<CR>
  nnoremap <buffer> <silent> <kMinus>      :silent! foldclose<CR>
  nnoremap <buffer> <silent> <kMultiply>   :silent! %foldopen!<CR>
  nnoremap <buffer> <silent> q             :close<CR>

  " Insert mode mappings
  inoremap <buffer> <silent> <CR>          <C-o>:call <SID>WindowJumpToTag('useopen')<CR>
  inoremap <buffer> <silent> <Return>      <C-o>:call <SID>WindowJumpToTag('useopen')<CR>
  inoremap <buffer> <silent> o             <C-o>:call <SID>WindowJumpToTag('newwin')<CR>
  inoremap <buffer> <silent> p             <C-o>:call <SID>WindowJumpToTag('preview')<CR>
  inoremap <buffer> <silent> P             <C-o>:call <SID>WindowJumpToTag('prevwin')<CR>
  if v:version >= 700
    inoremap <buffer> <silent> t           <C-o>:call <SID>WindowJumpToTag('checktab')<CR>
    inoremap <buffer> <silent> <C-t>       <C-o>:call <SID>WindowJumpToTag('newtab')<CR>
  endif
  inoremap <buffer> <silent> <2-LeftMouse> <C-o>:call <SID>WindowJumpToTag('useopen')<CR>
  inoremap <buffer> <silent> s             <C-o>:call <SID>ChangeSort('cmd', 'toggle', '')<CR>
  inoremap <buffer> <silent> u             <C-o>:call <SID>WindowUpdateFile()<CR>
  inoremap <buffer> <silent> d             <C-o>:call <SID>RemoveFile(-1, 1)<CR>
  inoremap <buffer> <silent> x             <C-o>:call <SID>WindowZoom()<CR>
  inoremap <buffer> <silent> [[            <C-o>:call <SID>WindowMoveToFile(-1)<CR>
  inoremap <buffer> <silent> <BS>          <C-o>:call <SID>WindowMoveToFile(-1)<CR>
  inoremap <buffer> <silent> ]]            <C-o>:call <SID>WindowMoveToFile(1)<CR>
  inoremap <buffer> <silent> <Tab>         <C-o>:call <SID>WindowMoveToFile(1)<CR>
  inoremap <buffer> <silent> <Space>       <C-o>:call <SID>WindowShowInfo()<CR>
  inoremap <buffer> <silent> <F1>          <C-o>:call <SID>WindowToggleHelpText()<CR>
  inoremap <buffer> <silent> +             <C-o>:silent! foldopen<CR>
  inoremap <buffer> <silent> -             <C-o>:silent! foldclose<CR>
  inoremap <buffer> <silent> *             <C-o>:silent! %foldopen!<CR>
  inoremap <buffer> <silent> =             <C-o>:silent! %foldclose<CR>
  inoremap <buffer> <silent> <kPlus>       <C-o>:silent! foldopen<CR>
  inoremap <buffer> <silent> <kMinus>      <C-o>:silent! foldclose<CR>
  inoremap <buffer> <silent> <kMultiply>   <C-o>:silent! %foldopen!<CR>
  inoremap <buffer> <silent> q             <C-o>:close<CR>

  " Map single left mouse click if the user wants this functionality
  if g:tlist_use_single_click == 1
    " Contributed by Bindu Wavell
    " attempt to perform single click mapping, it would be much
    " nicer if we could nnoremap <buffer> ... however vim does
    " not fire the <buffer> <leftmouse> when you use the mouse
    " to enter a buffer.
    let clickmap = ':if bufname("%") =~ "__Tag_List__" <bar> ' .
          \ 'call <SID>WindowJumpToTag("useopen") ' .
          \ '<bar> endif <CR>'
    if maparg('<leftmouse>', 'n') == ''
      " no mapping for leftmouse
      exe ':nnoremap <silent> <leftmouse> <leftmouse>' . clickmap
    else
      " we have a mapping
      let mapcmd = ':nnoremap <silent> <leftmouse> <leftmouse>'
      let mapcmd = mapcmd . substitute(substitute(
            \ maparg('<leftmouse>', 'n'), '|', '<bar>', 'g'),
            \ '\c^<leftmouse>', '', '')
      let mapcmd = mapcmd . clickmap
      exe mapcmd
    endif
  endif

  " Define the taglist autocommands
  augroup TagListAutoCmds
    autocmd!
    " Display the tag prototype for the tag under the cursor.
    autocmd CursorHold __Tag_List__ call s:WindowShowInfo()
    " Highlight the current tag periodically
    autocmd CursorHold * silent call s:WindowHighlightTag(
          \ fnamemodify(bufname('%'), ':p'), line('.'), 1, 0)
    " Adjust the Vim window width when taglist window is closed
    autocmd BufUnload __Tag_List__ call s:PostCloseCleanup()
    " Close the fold for this buffer when leaving the buffer
    if g:tlist_file_fold_auto_close
      autocmd BufEnter * silent call s:WindowOpenFileFold(expand('<abuf>'))
    endif
    " Exit Vim itself if only the taglist window is present (optional)
    if g:tlist_exit_onlywindow
      autocmd BufEnter __Tag_List__ nested call s:WindowExitOnlyWindow()
    endif
    if s:tlist_app_name != 'winmanager' &&
          \ !g:tlist_process_file_always &&
          \ (!has('gui_running') || !g:tlist_show_menu)
      " Auto refresh the taglist window
      autocmd BufEnter,BufWritePost,FileChangedShellPost * call taglist#Refresh()
    endif
    if !g:tlist_use_horiz_window
      if v:version < 700
        autocmd WinEnter * call s:WindowCheckWidth()
      endif
    endif
    if v:version >= 700
      autocmd TabEnter * silent call s:RefreshFolds()
    endif
  augroup END
endfunction

" Display the tags for all the files in the taglist window
function! s:WindowRefresh()
  call s:LogMsg('WindowRefresh()')
  " Set report option to a huge value to prevent informational messages
  " while deleting the lines
  let old_report = &report
  set report=99999
  " Mark the buffer as modifiable
  setlocal modifiable
  " Delete the contents of the buffer to the black-hole register
  silent! %delete _
  " As we have cleared the taglist window, mark all the files
  " as not visible
  let i = 0
  while i < s:tlist_file_count
    let s:tlist_{i}_visible = 0
    let i += 1
  endwhile
  if g:tlist_compact_format == 0
    " Display help in non-compact mode
    call s:WindowDisplayHelp()
  endif
  " Mark the buffer as not modifiable
  setlocal nomodifiable
  " Restore the report option
  let &report = old_report
  " If the tags for only one file should be displayed in the taglist
  " window, then no need to add the tags here. The bufenter autocommand
  " will add the tags for that file.
  if g:tlist_show_one_file
    return
  endif
  " List all the tags for the previously processed files
  " Do this only if taglist is configured to display tags for more than
  " one file. Otherwise, when tlist_show_one_file is configured,
  " tags for the wrong file will be displayed.
  let i = 0
  while i < s:tlist_file_count
    call s:WindowRefreshFile(s:tlist_{i}_filename,
          \ s:tlist_{i}_filetype)
    let i += 1
  endwhile
  if g:tlist_auto_update
    " Add and list the tags for all buffers in the Vim buffer list
    let i = 1
    let last_bufnum = bufnr('$')
    while i <= last_bufnum
      if buflisted(i)
        let fname = fnamemodify(bufname(i), ':p')
        let ftype = s:GetBufferFileType(i)
        " If the file doesn't support tag listing, skip it
        if !s:SkipFile(fname, ftype)
          call s:WindowRefreshFile(fname, ftype)
        endif
      endif
      let i += 1
    endwhile
  endif
  " If tlist_file_fold_auto_close option is set, then close all the folds
  if g:tlist_file_fold_auto_close
    " Close all the folds
    silent! %foldclose
  endif
  " Move the cursor to the top of the taglist window
  normal! gg
endfunction

" List the tags defined in the specified file in a Vim window
function! s:WindowRefreshFile(filename, ftype)
  call s:LogMsg('WindowRefreshFile(' . a:filename . ')')
  " First check whether the file already exists
  let fidx = s:GetFileIndex(a:filename)
  let file_listed = (fidx != -1) ? 1 : 0
  if !file_listed
    " Check whether this file is removed based on user request
    " If it is, then don't display the tags for this file
    if s:IsRemovedFile(a:filename)
      return
    endif
  endif
  if file_listed && s:tlist_{fidx}_visible
    " Check whether the file tags are currently valid
    if s:tlist_{fidx}_valid
      " Goto the first line in the file
      exe s:tlist_{fidx}_start
      " If the line is inside a fold, open the fold
      if foldclosed('.') != -1
        exe 'silent! ' . s:tlist_{fidx}_start . ',' .
              \ s:tlist_{fidx}_end . 'foldopen!'
      endif
      return
    endif
    " Discard and remove the tags for this file from display
    call s:DiscardTagInfo(fidx)
    call s:WindowRemoveFileFromDisplay(fidx)
  endif
  " Process and generate a list of tags defined in the file
  if !file_listed || !s:tlist_{fidx}_valid
    let ret_fidx = s:ProcessFile(a:filename, a:ftype)
    if ret_fidx == -1
      return
    endif
    let fidx = ret_fidx
  endif
  " Set report option to a huge value to prevent informational messages
  " while adding lines to the taglist window
  let old_report = &report
  set report=99999
  if g:tlist_show_one_file
    " Remove the previous file
    if s:tlist_cur_file_idx != -1
      call s:WindowRemoveFileFromDisplay(s:tlist_cur_file_idx)
      let s:tlist_{s:tlist_cur_file_idx}_visible = 0
      let s:tlist_{s:tlist_cur_file_idx}_start = 0
      let s:tlist_{s:tlist_cur_file_idx}_end = 0
    endif
    let s:tlist_cur_file_idx = fidx
  endif
  " Mark the buffer as modifiable
  setlocal modifiable
  " Add new files to the end of the window. For existing files, add them at
  " the same line where they were previously present. If the file is not
  " visible, then add it at the end
  if s:tlist_{fidx}_start == 0 || !s:tlist_{fidx}_visible
    if g:tlist_compact_format
      let s:tlist_{fidx}_start = line('$')
    else
      let s:tlist_{fidx}_start = line('$') + 1
    endif
  endif
  let s:tlist_{fidx}_visible = 1
  " Goto the line where this file should be placed
  if g:tlist_compact_format
    exe s:tlist_{fidx}_start
  else
    exe s:tlist_{fidx}_start - 1
  endif
  let txt = fnamemodify(s:tlist_{fidx}_filename, ':t') . ' (' .
        \ fnamemodify(s:tlist_{fidx}_filename, ':p:h') . ')'
  if g:tlist_compact_format == 0
    silent! put =txt
  else
    silent! put! =txt
    " Move to the next line
    exe line('.') + 1
  endif
  let file_start = s:tlist_{fidx}_start
  " Add the tag names grouped by tag type to the buffer with a title
  for ttype in keys(s:tlist_session_settings[a:ftype]['flags'])
    " Add the tag type only if there are tags for that type
    let fidx_ttype = 's:tlist_' . fidx . '_' . ttype
    let ttype_txt = {fidx_ttype}
    if ttype_txt != ''
      let txt = '  ' . s:tlist_session_settings[a:ftype]['flags'][ttype]
      if g:tlist_compact_format == 0
        let ttype_start_lnum = line('.') + 1
        silent! put =txt
      else
        let ttype_start_lnum = line('.')
        silent! put! =txt
      endif
      silent! put =ttype_txt
      let {fidx_ttype}_offset = ttype_start_lnum - file_start
      " Adjust the cursor position
      if g:tlist_compact_format == 0
        exe ttype_start_lnum + {fidx_ttype}_count
      else
        exe ttype_start_lnum + {fidx_ttype}_count + 1
      endif
      if g:tlist_compact_format == 0
        " Separate the tag types by a empty line
        silent! put =''
      endif
    endif
  endfor
  if s:tlist_{fidx}_tag_count == 0
    if g:tlist_compact_format == 0
      silent! put =''
    endif
  endif
  let s:tlist_{fidx}_end = line('.') - 1
  call s:CreateFoldsForFile(fidx)
  " Goto the starting line for this file,
  exe s:tlist_{fidx}_start
  if s:tlist_app_name == 'winmanager'
    " To handle a bug in the winmanager plugin, add a space at the
    " last line
    call setline('$', ' ')
  endif
  " Mark the buffer as not modifiable
  setlocal nomodifiable
  " Restore the report option
  let &report = old_report
  " Update the start and end line numbers for all the files following this
  " file
  let start = s:tlist_{fidx}_start
  " include the empty line after the last line
  if g:tlist_compact_format
    let end = s:tlist_{fidx}_end
  else
    let end = s:tlist_{fidx}_end + 1
  endif
  call s:WindowUpdateLineOffsets(fidx + 1, 1, end - start + 1)
  " Now that we have updated the taglist window, update the tags
  " menu (if present)
  if g:tlist_show_menu
    call s:MenuUpdateFile(1)
  endif
endfunction

" Close the taglist window and adjust the Vim window width
function! s:PostCloseCleanup()
  call s:LogMsg('PostCloseCleanup()')
  " Mark all the files as not visible
  let i = 0
  while i < s:tlist_file_count
    let s:tlist_{i}_visible = 0
    let i += 1
  endwhile
  " Remove the taglist autocommands
  silent! autocmd! TagListAutoCmds
  " Remove the left mouse click mapping if it was setup initially
  if g:tlist_use_single_click
    if hasmapto('<LeftMouse>')
      nunmap <LeftMouse>
    endif
  endif
  if s:tlist_app_name != 'winmanager'
    if g:tlist_use_horiz_window || g:tlist_inc_win_width == 0 ||
          \ s:tlist_winsize_chgd != 1 ||
          \ &columns < (80 + g:tlist_win_width)
      " No need to adjust window width if using horizontally split taglist
      " window or if columns is less than 101 or if the user chose not to
      " adjust the window width
    else
      " If the user didn't manually move the window, then restore the window
      " position to the pre-taglist position
      if s:tlist_pre_winx != -1 && s:tlist_pre_winy != -1 &&
            \ getwinposx() == s:tlist_winx &&
            \ getwinposy() == s:tlist_winy
        exe 'winpos ' . s:tlist_pre_winx . ' ' . s:tlist_pre_winy
      endif
      " Adjust the Vim window width
      let &columns= &columns - (g:tlist_win_width + 1)
    endif
  endif
  let s:tlist_winsize_chgd = -1
  " Reset taglist state variables
  if s:tlist_app_name == 'winmanager'
    let s:tlist_app_name = 'none'
  endif
  let s:tlist_window_initialized = 0
endfunction

" Mark the current window as the file window to use when jumping to a tag.
" Only if the current window is a non-plugin, non-preview and non-taglist
" window
function! s:WindowMarkFileWindow()
  if getbufvar('%', '&buftype') == '' && !&previewwindow
    let w:tlist_file_window = "yes"
  endif
endfunction

" Change the sort order of the tag listing
" caller == 'cmd', command used in the taglist window
" caller == 'menu', taglist menu
" action == 'toggle', toggle sort from name to order and vice versa
" action == 'set', set the sort order to sort_type
function! s:ChangeSort(caller, action, sort_type)
  call s:LogMsg('ChangeSort(caller = ' . a:caller .
        \ ', action = ' . a:action . ', sort_type = ' . a:sort_type . ')')
  if a:caller == 'cmd'
    let fidx = s:WindowGetFileIndexByLinenum(line('.'))
    if fidx == -1
      return
    endif
    " Remove the previous highlighting
    match none
  elseif a:caller == 'menu'
    let fidx = s:GetFileIndex(fnamemodify(bufname('%'), ':p'))
    if fidx == -1
      return
    endif
  endif
  if a:action == 'toggle'
    let sort_type = s:tlist_{fidx}_sort_type
    " Toggle the sort order from 'name' to 'order' and vice versa
    if sort_type == 'name'
      let s:tlist_{fidx}_sort_type = 'order'
    else
      let s:tlist_{fidx}_sort_type = 'name'
    endif
  else
    let s:tlist_{fidx}_sort_type = a:sort_type
  endif
  " Invalidate the tags listed for this file
  let s:tlist_{fidx}_valid = 0
  if a:caller  == 'cmd'
    " Save the current line for later restoration
    let curline = '\V\^' . escape(getline('.'), "\\") . '\$'
    call s:WindowRefreshFile(s:tlist_{fidx}_filename,
          \   s:tlist_{fidx}_filetype)
    exe s:tlist_{fidx}_start . ',' . s:tlist_{fidx}_end . 'foldopen!'
    " Go back to the cursor line before the tag list is sorted
    call search(curline, 'w')
    call s:MenuUpdateFile(1)
  else
    call s:MenuRemoveFile()
    call taglist#Refresh()
  endif
endfunction

" Update the tags displayed in the taglist window
function! s:WindowUpdateFile()
  call s:LogMsg('WindowUpdateFile()')
  let fidx = s:WindowGetFileIndexByLinenum(line('.'))
  if fidx == -1
    return
  endif
  " Remove the previous highlighting
  match none
  " Save the current line for later restoration
  let curline = '\V\^' . escape(getline('.'), "\\") . '\$'
  let s:tlist_{fidx}_valid = 0
  " Update the taglist window
  call s:WindowRefreshFile(s:tlist_{fidx}_filename,
        \ s:tlist_{fidx}_filetype)
  exe s:tlist_{fidx}_start . ',' . s:tlist_{fidx}_end . 'foldopen!'
  " Go back to the tag line before the list is updated
  call search(curline, 'w')
endfunction

" Highlight the current line
function! s:WindowHighlightLine()
  " Clear previously selected name
  match none
  " Highlight the current line
  if g:tlist_display_prototype == 0
    let pat = '/\%' . line('.') . 'l\s\+\zs.*/'
  else
    let pat = '/\%' . line('.') . 'l.*/'
  endif
  exe 'match TagListTagName ' . pat
endfunction

" Open the specified file in either a new window or an existing window
" and place the cursor at the specified tag pattern
function! s:WindowOpenFile(win_ctrl, filename, tagpat)
  call s:LogMsg('WindowOpenFile(' . a:filename . ',' .
        \ a:win_ctrl . ')')
  let prev_tlist_skip_refresh = s:tlist_skip_refresh
  let s:tlist_skip_refresh = 1
  if s:tlist_app_name == 'winmanager'
    " Let the winmanager edit the file
    call WinManagerFileEdit(a:filename, a:win_ctrl == 'newwin')
  else
    if a:win_ctrl == 'newtab'
      " Create a new tab
      exe 'tabnew ' . escape(a:filename, ' ')
      " Open the taglist window in the new tab
      call taglist#WindowOpen()
    endif
    if a:win_ctrl == 'checktab'
      " Check whether the file is present in any of the tabs.
      " If the file is present in the current tab, then use the
      " current tab.
      if bufwinnr(a:filename) != -1
        let file_present_in_tab = 1
        let i = tabpagenr()
      else
        let i = 1
        let bnum = bufnr(a:filename)
        let file_present_in_tab = 0
        while i <= tabpagenr('$')
          if index(tabpagebuflist(i), bnum) != -1
            let file_present_in_tab = 1
            break
          endif
          let i += 1
        endwhile
      endif
      if file_present_in_tab
        " Goto the tab containing the file
        exe 'tabnext ' . i
      else
        " Open a new tab
        exe 'tabnew ' . escape(a:filename, ' ')
        " Open the taglist window
        call taglist#WindowOpen()
      endif
    endif
    let winnum = -1
    if a:win_ctrl == 'prevwin'
      " Open the file in the previous window, if it is usable
      let cur_win = winnr()
      wincmd p
      if &buftype == '' && !&previewwindow
        exe "edit " . escape(a:filename, ' ')
        let winnum = winnr()
      else
        " Previous window is not usable
        exe cur_win . 'wincmd w'
      endif
    endif
    " Goto the window containing the file.  If the window is not there, open a
    " new window
    if winnum == -1
      let winnum = bufwinnr(a:filename)
    endif
    if winnum == -1
      " Locate the previously used window for opening a file
      let fwin_num = 0
      let first_usable_win = 0
      let i = 1
      let bnum = winbufnr(i)
      while bnum != -1
        if getwinvar(i, 'tlist_file_window') == 'yes'
          let fwin_num = i
          break
        endif
        if first_usable_win == 0 &&
              \ getbufvar(bnum, '&buftype') == '' &&
              \ !getwinvar(i, '&previewwindow')
          " First non-taglist, non-plugin and non-preview window
          let first_usable_win = i
        endif
        let i = i + 1
        let bnum = winbufnr(i)
      endwhile
      " If a previously used window is not found, then use the first
      " non-taglist window
      if fwin_num == 0
        let fwin_num = first_usable_win
      endif
      if fwin_num != 0
        " Jump to the file window
        exe fwin_num . "wincmd w"
        " If the user asked to jump to the tag in a new window, then split
        " the existing window into two.
        if a:win_ctrl == 'newwin'
          split
        endif
        exe "edit " . escape(a:filename, ' ')
      else
        " Open a new window
        let cmd_mod = (v:version >= 700) ? 'keepalt ' : ''
        if g:tlist_use_horiz_window
          exe cmd_mod . 'leftabove split ' . escape(a:filename, ' ')
        else
          if winbufnr(2) == -1
            " Only the taglist window is present
            if g:tlist_use_right_window
              exe cmd_mod . 'leftabove vertical split ' .
                    \ escape(a:filename, ' ')
            else
              exe cmd_mod . 'rightbelow vertical split ' .
                    \ escape(a:filename, ' ')
            endif
            " Go to the taglist window to change the window size to
            " the user configured value
            call s:ExeCmdWithoutAcmds('wincmd p')
            if g:tlist_use_horiz_window
              exe 'resize ' . g:tlist_win_height
            else
              exe 'vertical resize ' . g:tlist_win_width
            endif
            " Go back to the file window
            call s:ExeCmdWithoutAcmds('wincmd p')
          else
            " A plugin or help window is also present
            wincmd w
            exe cmd_mod . 'leftabove split ' . escape(a:filename, ' ')
          endif
        endif
      endif
      " Mark the window, so that it can be reused.
      call s:WindowMarkFileWindow()
    else
      if v:version >= 700
        " If the file is opened in more than one window, then check
        " whether the last accessed window has the selected file.
        " If it does, then use that window.
        let lastwin_bufnum = winbufnr(winnr('#'))
        if bufnr(a:filename) == lastwin_bufnum
          let winnum = winnr('#')
        endif
      endif
      exe winnum . 'wincmd w'
      " If the user asked to jump to the tag in a new window, then split the
      " existing window into two.
      if a:win_ctrl == 'newwin'
        split
      endif
    endif
  endif
  " Jump to the tag
  if a:tagpat != ''
    " Add the current cursor position to the jump list, so that user can
    " jump back using the ' and ` marks.
    mark '
    silent call search(a:tagpat, 'w')
    " Bring the line to the middle of the window
    normal! z.
    " If the line is inside a fold, open the fold
    if foldclosed('.') != -1
      .foldopen
    endif
  endif
  " If the user selects to preview the tag then jump back to the
  " taglist window
  if a:win_ctrl == 'preview'
    " Go back to the taglist window
    let winnum = bufwinnr(g:TagList_title)
    exe winnum . 'wincmd w'
  else
    " If the user has selected to close the taglist window, when a
    " tag is selected, close the taglist  window
    if g:tlist_close_on_select
      call s:WindowGotoWindow()
      close
      " Go back to the window displaying the selected file
      let wnum = bufwinnr(a:filename)
      if wnum != -1 && wnum != winnr()
        call s:ExeCmdWithoutAcmds(wnum . 'wincmd w')
      endif
    endif
  endif
  let s:tlist_skip_refresh = prev_tlist_skip_refresh
endfunction

" Jump to the location of the current tag
" win_ctrl == useopen - Reuse the existing file window
" win_ctrl == newwin - Open a new window
" win_ctrl == preview - Preview the tag
" win_ctrl == prevwin - Open in previous window
" win_ctrl == newtab - Open in new tab
function! s:WindowJumpToTag(win_ctrl)
  call s:LogMsg('WindowJumpToTag(' . a:win_ctrl . ')')
  " Do not process comment lines and empty lines
  let curline = getline('.')
  if curline =~ '^\s*$' || curline[0] == '"'
    return
  endif
  " If inside a closed fold, then use the first line of the fold
  " and jump to the file.
  let lnum = foldclosed('.')
  if lnum == -1
    " Jump to the selected tag or file
    let lnum = line('.')
  else
    " Open the closed fold
    .foldopen!
  endif
  let fidx = s:WindowGetFileIndexByLinenum(lnum)
  if fidx == -1
    return
  endif
  " Get the tag output for the current tag
  let tidx = s:WindowGetTagIndex(fidx, lnum)
  if tidx != 0
    let tagpat = s:GetTagSearchPat(fidx, tidx)
    " Highlight the tagline
    call s:WindowHighlightLine()
  else
    " Selected a line which is not a tag name. Just edit the file
    let tagpat = ''
  endif
  call s:WindowOpenFile(a:win_ctrl, s:tlist_{fidx}_filename, tagpat)
endfunction

" Display information about the entry under the cursor
function! s:WindowShowInfo()
  call s:LogMsg('WindowShowInfo()')
  " Clear the previously displayed line
  echo
  " Do not process comment lines and empty lines
  let curline = getline('.')
  if curline =~ '^\s*$' || curline[0] == '"'
    return
  endif
  " If inside a fold, then don't display the prototype
  if foldclosed('.') != -1
    return
  endif
  let lnum = line('.')
  " Get the file index
  let fidx = s:WindowGetFileIndexByLinenum(lnum)
  if fidx == -1
    return
  endif
  if lnum == s:tlist_{fidx}_start
    " Cursor is on a file name
    let fname = s:tlist_{fidx}_filename
    if strlen(fname) > 50
      let fname = fnamemodify(fname, ':t')
    endif
    echo fname . ', File Type: ' . s:tlist_{fidx}_filetype .
          \  ', Tag Count: ' . s:tlist_{fidx}_tag_count
    return
  endif
  " Get the tag output line for the current tag
  let tidx = s:WindowGetTagIndex(fidx, lnum)
  if tidx == 0
    " Cursor is on a tag type
    let ttype = s:WindowGetTagTypeByLinenum(fidx, lnum)
    if ttype == ''
      return
    endif
    let ttype_name = ''
    let ftype = s:tlist_{fidx}_filetype
    for flag in keys(s:tlist_session_settings[ftype]['flags'])
      if ttype == flag
        let ttype_name = s:tlist_session_settings[ftype]['flags'][flag]
        break
      endif
    endfor
    echo 'Tag Type: ' . ttype_name .
          \ ', Tag Count: ' . s:tlist_{fidx}_{ttype}_count
    return
  endif
  " Get the tag search pattern and display it
  let proto = s:GetTagPrototype(fidx, tidx)
  echo strpart(proto, 0, &columns - 1)
endfunction

" Find the tag idx nearest to the supplied line number
" Returns -1, if a tag couldn't be found for the specified line number
function! s:FindNearestTagIdx(fidx, linenum)
  let sort_type = s:tlist_{a:fidx}_sort_type
  let left = 1
  let right = s:tlist_{a:fidx}_tag_count
  if sort_type == 'order'
    " Tags sorted by order, use a binary search.
    " The idea behind this function is taken from the ctags.vim script (by
    " Alexey Marinichev) available at the Vim online website.
    " If the current line is the less than the first tag, then no need to
    " search
    let first_lnum = s:GetTagLinenum(a:fidx, 1)
    if a:linenum < first_lnum
      return -1
    endif
    while left < right
      let middle = (right + left + 1) / 2
      let middle_lnum = s:GetTagLinenum(a:fidx, middle)
      if middle_lnum == a:linenum
        let left = middle
        break
      endif
      if middle_lnum > a:linenum
        let right = middle - 1
      else
        let left = middle
      endif
    endwhile
  else
    " Tags sorted by name, use a linear search. (contributed by Dave
    " Eggum).
    " Look for a tag with a line number less than or equal to the supplied
    " line number. If multiple tags are found, then use the tag with the
    " line number closest to the supplied line number. IOW, use the tag
    " with the highest line number.
    let closest_lnum = 0
    let final_left = 0
    while left <= right
      let lnum = s:GetTagLinenum(a:fidx, left)
      if lnum < a:linenum && lnum > closest_lnum
        let closest_lnum = lnum
        let final_left = left
      elseif lnum == a:linenum
        let closest_lnum = lnum
        let final_left = left
        break
      else
        let left = left + 1
      endif
    endwhile
    if closest_lnum == 0
      return -1
    endif
    if left >= right
      let left = final_left
    endif
  endif
  return left
endfunction

" Highlight the current tag
" cntx == 1, Called by the taglist plugin itself
" cntx == 2, Forced by the user through the TlistHighlightTag command
" center = 1, move the tag line to the center of the taglist window
function! s:WindowHighlightTag(filename, cur_lnum, cntx, center)
  " Highlight the current tag only if the user configured the
  " taglist plugin to do so or if the user explictly invoked the
  " command to highlight the current tag.
  if !g:tlist_auto_highlight_tag && a:cntx == 1
    return
  endif
  if a:filename == ''
    return
  endif
  " Make sure the taglist window is present
  let winnum = bufwinnr(g:TagList_title)
  if winnum == -1
    call s:WarningMsg('Error: Taglist window is not open')
    return
  endif
  let fidx = s:GetFileIndex(a:filename)
  if fidx == -1
    return
  endif
  " If the file is currently not displayed in the taglist window, then retrn
  if !s:tlist_{fidx}_visible
    return
  endif
  " If there are no tags for this file, then no need to proceed further
  if s:tlist_{fidx}_tag_count == 0
    return
  endif
  " Ignore all autocommands
  let old_ei = &eventignore
  set eventignore=all
  " Save the original window number
  let org_winnr = winnr()
  if org_winnr == winnum
    let in_taglist_window = 1
  else
    let in_taglist_window = 0
  endif
  " Go to the taglist window
  if !in_taglist_window
    exe winnum . 'wincmd w'
  endif
  " Clear previously selected name
  match none
  let tidx = s:FindNearestTagIdx(fidx, a:cur_lnum)
  if tidx == -1
    " Make sure the current tag line is visible in the taglist window.
    " Calling the winline() function makes the line visible.  Don't know
    " of a better way to achieve this.
    let lnum = line('.')
    if lnum < s:tlist_{fidx}_start || lnum > s:tlist_{fidx}_end
      " Move the cursor to the beginning of the file
      exe s:tlist_{fidx}_start
    endif
    if foldclosed('.') != -1
      .foldopen
    endif
    call winline()
    if !in_taglist_window
      exe org_winnr . 'wincmd w'
    endif
    " Restore the autocommands
    let &eventignore = old_ei
    return
  endif
  " Extract the tag type
  let ttype = s:GetTagTypeByTag(fidx, tidx)
  " Compute the line number
  " Start of file + Start of tag type + offset
  let lnum = s:tlist_{fidx}_start + s:tlist_{fidx}_{ttype}_offset +
        \ s:tlist_{fidx}_{tidx}_ttype_idx
  " Goto the line containing the tag
  exe lnum
  " Open the fold
  if foldclosed('.') != -1
    .foldopen
  endif
  if a:center
    " Move the tag line to the center of the taglist window
    normal! z.
  else
    " Make sure the current tag line is visible in the taglist window.
    " Calling the winline() function makes the line visible.  Don't know
    " of a better way to achieve this.
    call winline()
  endif
  " Highlight the tag name
  call s:WindowHighlightLine()
  " Go back to the original window
  if !in_taglist_window
    exe org_winnr . 'wincmd w'
  endif
  " Restore the autocommands
  let &eventignore = old_ei
  return
endfunction

" Return the list of file names in the taglist. The names are separated
" by a newline ('\n')
function! GetFilenames()
  let fnames = ''
  let i = 0
  while i < s:tlist_file_count
    let fnames = fnames . s:tlist_{i}_filename . "\n"
    let i = i + 1
  endwhile
  return fnames
endfunction

" Move the cursor to the beginning of the current file or the next file
" or the previous file in the taglist window
" dir == -1, move to start of current or previous function
" dir == 1, move to start of next function
function! s:WindowMoveToFile(dir)
  if foldlevel('.') == 0
    " Cursor is on a non-folded line (it is not in any of the files)
    " Move it to a folded line
    if a:dir == -1
      normal! zk
    else
      " While moving down to the start of the next fold,
      " no need to do go to the start of the next file.
      normal! zj
      return
    endif
  endif
  let fidx = s:WindowGetFileIndexByLinenum(line('.'))
  if fidx == -1
    return
  endif
  let cur_lnum = line('.')
  if a:dir == -1
    if cur_lnum > s:tlist_{fidx}_start
      " Move to the beginning of the current file
      exe s:tlist_{fidx}_start
      return
    endif
    if fidx != 0
      " Move to the beginning of the previous file
      let fidx = fidx - 1
    else
      " Cursor is at the first file, wrap around to the last file
      let fidx = s:tlist_file_count - 1
    endif
    exe s:tlist_{fidx}_start
    return
  else
    " Move to the beginning of the next file
    let fidx = fidx + 1
    if fidx >= s:tlist_file_count
      " Cursor is at the last file, wrap around to the first file
      let fidx = 0
    endif
    if s:tlist_{fidx}_start != 0
      exe s:tlist_{fidx}_start
    endif
    return
  endif
endfunction

" Open the fold for the specified file and close the fold for all the
" other files
function! s:WindowOpenFileFold(acmd_bufnr)
  call s:LogMsg('WindowOpenFileFold(' . a:acmd_bufnr . ')')
  " Make sure the taglist window is present
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    call s:WarningMsg('Error - Taglist window is not open')
    return
  endif
  " Save the original window number
  let org_winnr = winnr()
  if org_winnr == tlist_winnr
    let in_taglist_window = 1
  else
    let in_taglist_window = 0
  endif
  if in_taglist_window
    " When entering the taglist window, no need to update the folds
    return
  endif
  " Go to the taglist window
  if !in_taglist_window
    call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
  endif
  " Close all the folds
  silent! %foldclose
  " Get tag list index of the specified file
  let fname = fnamemodify(bufname(a:acmd_bufnr + 0), ':p')
  if filereadable(fname)
    let fidx = s:GetFileIndex(fname)
    if fidx != -1
      " Open the fold for the file
      exe "silent! " . s:tlist_{fidx}_start . "," .
            \ s:tlist_{fidx}_end . "foldopen"
    endif
  endif
  " Go back to the original window
  if !in_taglist_window
    call s:ExeCmdWithoutAcmds(org_winnr . 'wincmd w')
  endif
endfunction

" Create the folds in the taglist window for the specified file
function! s:CreateFoldsForFile(fidx)
  let ftype = s:tlist_{a:fidx}_filetype
  " Create the folds for each tag type in a file
  for ttype in keys(s:tlist_session_settings[ftype]['flags'])
    if s:tlist_{a:fidx}_{ttype}_count
      let s = s:tlist_{a:fidx}_start + s:tlist_{a:fidx}_{ttype}_offset
      let e = s + s:tlist_{a:fidx}_{ttype}_count
      exe s . ',' . e . 'fold'
    endif
  endfor
  exe s:tlist_{a:fidx}_start . ',' . s:tlist_{a:fidx}_end . 'fold'
  exe 'silent! ' . s:tlist_{a:fidx}_start . ',' .
        \ s:tlist_{a:fidx}_end . 'foldopen!'
endfunction

" Remove and create the folds for all the files displayed in the taglist
" window. Used after entering a tab. If this is not done, then the folds
" are not properly created for taglist windows displayed in multiple tabs.
function! s:RefreshFolds()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    return
  endif
  let save_wnum = winnr()
  exe tlist_winnr . 'wincmd w'
  " First remove all the existing folds
  normal! zE
  if g:tlist_show_one_file
    " If only one file is displayed in the taglist window, then there
    " is no need to refresh the folds for the tags as the tags for the
    " current file will be removed anyway.
  else
    " Create the folds for each file in the tag list
    let fidx = 0
    while fidx < s:tlist_file_count
      call s:CreateFoldsForFile(fidx)
      let fidx = fidx + 1
    endwhile
  endif
  exe save_wnum . 'wincmd w'
endfunction

" Add base menu
function! s:MenuAddBaseMenu()
  call s:LogMsg('Adding the base menu')
  " Add main menu
  an <silent> T&ags.Toggle\ Tag\ List     :call taglist#WindowToggle()<CR>
  an T&ags.-SEP0-                         :
  an <silent> T&ags.Refresh\ Menu         :call <SID>MenuRefresh()<CR>
  an <silent> T&ags.Sort\ Menu\ By.Name   :call <SID>ChangeSort('menu', 'set', 'name')<CR>
  an <silent> T&ags.Sort\ Menu\ By.Order  :call <SID>ChangeSort('menu', 'set', 'order')<CR>
  an T&ags.-SEP1-                         :
  " Add popup menu
  if &mousemodel =~ 'popup'
    an PopUp.-TAGLIST-SEP-                        :
    an <silent> PopUp.T&ags.Refresh\ Menu         :call <SID>MenuRefresh()<CR>
    an <silent> PopUp.T&ags.Sort\ Menu\ By.Name   :call <SID>ChangeSort('menu', 'set', 'name')<CR>
    an <silent> PopUp.T&ags.Sort\ Menu\ By.Order  :call <SID>ChangeSort('menu', 'set', 'order')<CR>
    an PopUp.T&ags.-SEP1-                         :
  endif
endfunction

" Get the menu command for the specified tag type
" fidx  - File type index
" ftype - File type
" flag  - Tag flag
function! s:MenuGetTagTypeCmd(fidx, ftype, flag)
  " If the tag type name contains space characters, escape it. This
  " will be used to create the menu entries.
  let ttype_fullname = escape(s:tlist_session_settings[a:ftype]['flags'][a:flag], ' ')
  " Curly brace variable name optimization
  let fidx_ttype = a:fidx . '_' . a:flag
  " Number of tag entries for this tag type
  let tcnt = s:tlist_{fidx_ttype}_count
  if tcnt == 0 " No entries for this tag type
    return ''
  endif
  let mcmd = ''
  " Create the menu items for the tags.
  " Depending on the number of tags of this type, split the menu into
  " multiple sub-menus, if needed.
  if tcnt > g:tlist_max_submenu_items
    let j = 1
    while j <= tcnt
      let final_index = j + g:tlist_max_submenu_items - 1
      if final_index > tcnt
        let final_index = tcnt
      endif
      " Extract the first and last tag name and form the
      " sub-menu name
      let tidx = s:tlist_{fidx_ttype}_{j}
      let first_tag = s:tlist_{a:fidx}_{tidx}_tag_name
      let tidx = s:tlist_{fidx_ttype}_{final_index}
      let last_tag = s:tlist_{a:fidx}_{tidx}_tag_name
      " Truncate the names, if they are greater than the
      " max length
      let first_tag = strpart(first_tag, 0, g:tlist_max_tag_length)
      let last_tag = strpart(last_tag, 0, g:tlist_max_tag_length)
      " Form the menu command prefix
      let m_prefix = 'anoremenu <silent> T\&ags.' . ttype_fullname . '.'
      let m_prefix = m_prefix . first_tag . '\.\.\.' . last_tag . '.'
      " Character prefix used to number the menu items (hotkey)
      let m_prefix_idx = 0
      while j <= final_index
        let tidx = s:tlist_{fidx_ttype}_{j}
        let tname = s:tlist_{a:fidx}_{tidx}_tag_name
        let mcmd = mcmd . m_prefix . '\&' .
              \ s:menu_char_prefix[m_prefix_idx] . '\.' .
              \ tname . ' :call <SID>MenuJumpToTag(' .
              \ tidx . ')<CR>|'
        let m_prefix_idx = m_prefix_idx + 1
        let j = j + 1
      endwhile
    endwhile
  else
    " Character prefix used to number the menu items (hotkey)
    let m_prefix_idx = 0
    let m_prefix = 'anoremenu <silent> T\&ags.' . ttype_fullname . '.'
    let j = 1
    while j <= tcnt
      let tidx = s:tlist_{fidx_ttype}_{j}
      let tname = s:tlist_{a:fidx}_{tidx}_tag_name
      let mcmd = mcmd . m_prefix . '\&' .
            \ s:menu_char_prefix[m_prefix_idx] . '\.' .
            \ tname . ' :call <SID>MenuJumpToTag(' . tidx
            \ . ')<CR>|'
      let m_prefix_idx = m_prefix_idx + 1
      let j = j + 1
    endwhile
  endif
  return mcmd
endfunction

" Update the taglist menu with the tags for the specified file
function! s:MenuFileRefresh(fidx)
  call s:LogMsg('Refreshing the tag menu for ' . s:tlist_{a:fidx}_filename)
  exe s:tlist_{a:fidx}_menu_cmd
  " Update the popup menu (if enabled)
  if &mousemodel =~ 'popup'
    let cmd = substitute(s:tlist_{a:fidx}_menu_cmd, ' T\\&ags\.',
          \ ' PopUp.T\\\&ags.', "g")
    exe cmd
  endif
  " The taglist menu is not empty now
  let s:tlist_menu_empty = 0
endfunction

" Add the taglist menu
function! s:MenuUpdateFile(clear_menu)
  if !has('gui_running')
    " Not running in GUI mode
    return
  endif
  call s:LogMsg('Updating the tag menu, clear_menu = ' . a:clear_menu)
  " Remove the tags menu
  if a:clear_menu
    call s:MenuRemoveFile()
  endif
  " Skip buffers with 'buftype' set to nofile, nowrite, quickfix or help
  if &buftype != ''
    return
  endif
  let filename = fnamemodify(bufname('%'), ':p')
  let ftype = s:GetBufferFileType(bufname('%'))
  " If the file doesn't support tag listing, skip it
  if s:SkipFile(filename, ftype)
    return
  endif
  let fidx = s:GetFileIndex(filename)
  if fidx == -1 || !s:tlist_{fidx}_valid
    " Check whether this file is removed based on user request
    " If it is, then don't display the tags for this file
    if s:IsRemovedFile(filename)
      return
    endif
    " Process the tags for the file
    let fidx = s:ProcessFile(filename, ftype)
    if fidx == -1
      return
    endif
  endif
  let fname = escape(fnamemodify(bufname('%'), ':t'), '.')
  if fname != ''
    exe 'anoremenu T&ags.' .  fname . ' <Nop>'
    anoremenu T&ags.-SEP2-           :
  endif
  if !s:tlist_{fidx}_tag_count
    return
  endif
  if s:tlist_{fidx}_menu_cmd != ''
    " Update the menu with the cached command
    call s:MenuFileRefresh(fidx)
    return
  endif
  " We are going to add entries to the tags menu, so the menu won't be
  " empty
  let s:tlist_menu_empty = 0
  let cmd = ''
  " Determine whether the tag type name needs to be added to the menu
  " If more than one tag type is present in the taglisting for a file,
  " then the tag type name needs to be present
  for ttype in keys(s:tlist_session_settings[ftype]['flags'])
    if s:tlist_{fidx}_{ttype}_count
      let mcmd = s:MenuGetTagTypeCmd(fidx, ftype, ttype)
      if mcmd != ''
        let cmd = cmd . mcmd
      endif
    endif
  endfor
  " Cache the menu command for reuse
  let s:tlist_{fidx}_menu_cmd = cmd
  " Update the menu
  call s:MenuFileRefresh(fidx)
endfunction

" Remove the tags displayed in the tags menu
function! s:MenuRemoveFile()
  if !has('gui_running') || s:tlist_menu_empty
    return
  endif
  call s:LogMsg('Removing the tags menu for a file')
  " Cleanup the Tags menu
  silent! unmenu T&ags
  if &mousemodel =~ 'popup'
    silent! unmenu PopUp.T&ags
  endif
  " Add a dummy menu item to retain teared off menu
  noremenu T&ags.Dummy l
  silent! unmenu! T&ags
  if &mousemodel =~ 'popup'
    silent! unmenu! PopUp.T&ags
  endif
  call s:MenuAddBaseMenu()
  " Remove the dummy menu item
  unmenu T&ags.Dummy
  let s:tlist_menu_empty = 1
endfunction

" Refresh the taglist menu
function! s:MenuRefresh()
  call s:LogMsg('Refreshing the tags menu')
  let fidx = s:GetFileIndex(fnamemodify(bufname('%'), ':p'))
  if fidx != -1
    " Invalidate the cached menu command
    let s:tlist_{fidx}_menu_cmd = ''
  endif
  " Update the taglist, menu and window
  call taglist#UpdateCurrentFile()
endfunction

" Jump to the selected tag
function! s:MenuJumpToTag(tidx)
  let fidx = s:GetFileIndex(fnamemodify(bufname('%'), ':p'))
  if fidx == -1
    return
  endif
  let tagpat = s:GetTagSearchPat(fidx, a:tidx)
  if tagpat == ''
    return
  endif
  " Add the current cursor position to the jump list, so that user can
  " jump back using the ' and ` marks.
  mark '
  silent call search(tagpat, 'w')
  " Bring the line to the middle of the window
  normal! z.
  " If the line is inside a fold, open the fold
  if foldclosed('.') != -1
    .foldopen
  endif
endfunction

" }}}1

" Restore cpotions.
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set fdm=marker fdl=0:
