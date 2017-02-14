" File: taglist.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 4.6
" Last Modified: Feb 26, 2013
" Copyright: Copyright (C) 2002-2013 Yegappan Lakshmanan
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            taglist.vim is provided *as is* and comes with no warranty of any
"            kind, either expressed or implied. In no event will the copyright
"            holder be liable for any damamges resulting from the use of this
"            software.
"
" The "TagList" plugin is a source code browser plugin for Vim and provides an
" overview of the structure of the programming language files and enables you
" to efficiently browse through source code files for various programming
" languages.
"
" You can visit the taglist plugin home page for more information:
"
"       http://vim-taglist.sourceforge.net
"
" You can subscribe to the taglist mailing list to post your questions
" or suggestions for improvement or to report bugs. Visit the following
" page for subscribing to the mailing list:
"
"       http://groups.yahoo.com/group/taglist/
"
" For more information about using this plugin, after installing the
" taglist plugin, use the ":help taglist" command.
"
" Installation
" ------------
" 1. Download the taglist.zip file and unzip the files to the $HOME/.vim
"    or the $HOME/vimfiles or the $VIM/vimfiles directory. This should
"    unzip the following two files (the directory structure should be
"    preserved):
"
"       plugin/taglist.vim - main taglist plugin file
"       doc/taglist.txt    - documentation (help) file
"
"    Refer to the 'add-plugin', 'add-global-plugin' and 'runtimepath'
"    Vim help pages for more details about installing Vim plugins.
" 2. Change to the $HOME/.vim/doc or $HOME/vimfiles/doc or
"    $VIM/vimfiles/doc directory, start Vim and run the ":helptags ."
"    command to process the taglist help file.
" 3. If the exuberant ctags utility is not present in your PATH, then set the
"    tlist_ctags_cmd variable to point to the location of the exuberant ctags
"    utility (not to the directory) in the .vimrc file.
" 4. If you are running a terminal/console version of Vim and the
"    terminal doesn't support changing the window width then set the
"    'tlist_inc_win_width' variable to 0 in the .vimrc file.
" 5. Restart Vim.
" 6. You can now use the ":TlistToggle" command to open/close the taglist
"    window. You can use the ":help taglist" command to get more
"    information about using the taglist plugin.

" LOAD GUARD: {{{1
if exists('g:loaded_taglist')
  finish
elseif !exists('*system')
  " The taglist plugin requires the built-in Vim system() function. If this
  " function is not available, then don't load the plugin.
  echomsg 'TagList: Vim system() built-in function is not available. ' .
        \ 'Plugin is not loaded.'
  finish
endif
let g:loaded_taglist = 1
" }}}1

" Save cpoptions.
let s:cpo_save = &cpo
set cpo&vim

" Location of the exuberant ctags tool
if !exists('g:tlist_ctags_cmd')
  if has('win32') && len(globpath(&runtimepath, 'tools/ctags.exe', 0, 1)) > 0
    let g:tlist_ctags_cmd = globpath(&runtimepath, 'tools/ctags.exe', 0, 1)[0]
  elseif executable('exuberant-ctags')
    let g:tlist_ctags_cmd = 'exuberant-ctags' " Debian Linux
  elseif executable('exctags')
    let g:tlist_ctags_cmd = 'exctags' " Free-BSD
  elseif executable('ctags')
    let g:tlist_ctags_cmd = 'ctags'
  elseif executable('ctags.exe')
    let g:tlist_ctags_cmd = 'ctags.exe'
  elseif executable('tags')
    let g:tlist_ctags_cmd = 'tags'
  else
    echomsg 'TagList: Exuberant ctags (http://ctags.sf.net) ' .
          \ 'not found in PATH. Plugin is not loaded.'
    let g:loaded_taglist = 'no'
    let &cpo = s:cpo_save
    finish
  endif
endif
" Location of the ctags configuration file
if !exists('g:tlist_ctags_conf')
  if len(globpath(&runtimepath, 'tools/ctags.conf', 0, 1)) > 0
    let g:tlist_ctags_conf = globpath(&runtimepath, 'tools/ctags.conf', 0, 1)[0]
  endif
endif

" Automatically open the taglist window on Vim startup
let g:tlist_auto_open = get(g:, 'tlist_auto_open', 0)
" When the taglist window is toggle opened, move the cursor to the taglist window
let g:tlist_gain_focus_on_toggleopen = get(g:, 'tlist_gain_focus_on_toggleopen', 0)
" Process files even when the taglist window is not open
let g:tlist_process_file_always = get(g:, 'tlist_process_file_always', 0)
" Show tags menu
let g:tlist_show_menu = get(g:, 'tlist_show_menu', 0)
" Tag listing sort type - 'name' or 'order'
let g:tlist_sort_type = get(g:, 'tlist_sort_type', 'order')
" Tag listing window split (horizontal/vertical) control
let g:tlist_use_horiz_window = get(g:, 'tlist_use_horiz_window', 0)
" Open the vertically split taglist window on the left or on the right
" side. This setting is relevant only if tlist_use_horiz_window is set to
" zero (i.e.: only for vertically split windows)
let g:tlist_use_right_window = get(g:, 'tlist_use_right_window', 0)
" Increase Vim window width to display vertically split taglist window.
let g:tlist_inc_win_width = get(g:, 'tlist_inc_win_width', 1)
" Vertically split taglist window width setting
let g:tlist_win_width = get(g:, 'tlist_win_width', 30)
" Horizontally split taglist window height setting
let g:tlist_win_height = get(g:, 'tlist_win_height', 10)
" Display tag prototypes or tag names in the taglist window
let g:tlist_display_prototype = get(g:, 'tlist_display_prototype', 0)
" Display tag scopes in the taglist window
let g:tlist_display_tag_scope = get(g:, 'tlist_display_tag_scope', 1)
" Use single left mouse click to jump to a tag. By default this is disabled.
" Only double click using the mouse will be processed.
let g:tlist_use_single_click = get(g:, 'tlist_use_single_click', 0)
" Control whether additional help is displayed as part of the taglist or
" not, as well as whether empty lines are used to separate the tag tree.
let g:tlist_compact_format = get(g:, 'tlist_compact_format', 0)
" Exit Vim if the taglist window is the only window currently open.
let g:tlist_exit_onlywindow = get(g:, 'tlist_exit_onlywindow', 0)
" Automatically close the folds for the non-active files
let g:tlist_file_fold_auto_close = get(g:, 'tlist_file_fold_auto_close', 0)
" Close the taglist window when a tag is selected
let g:tlist_close_on_select = get(g:, 'tlist_close_on_select', 0)
" Automatically update the taglist window to display tags
let g:tlist_auto_update = get(g:, 'tlist_auto_update', 0)
" Automatically highlight the current tag
let g:tlist_auto_highlight_tag = get(g:, 'tlist_auto_highlight_tag', 1)
" Automatically highlight the current tag on entering a buffer
let g:tlist_highlight_tag_on_bufenter = get(g:, 'tlist_highlight_tag_on_bufenter', 1)
" Enable fold column to display the folding for the tag tree
let g:tlist_enable_fold_column = get(g:, 'tlist_enable_fold_column', 1)
" Display the tags for only one file in the taglist window
let g:tlist_show_one_file = get(g:, 'tlist_show_one_file', 0)
" Maximum number of items listed in the sub-menu
let g:tlist_max_submenu_items = get(g:, 'tlist_max_submenu_items', 20)
" Maximum tag length
let g:tlist_max_tag_length = get(g:, 'tlist_max_tag_length', 10)

" Do not change the name of the taglist title variable. The winmanager
" plugin relies on this name to determine the title for the taglist
" plugin.
let TagList_title = "__Tag_List__"

" Commands to manage the taglist window
command! -bar                         TlistLock              let tlist_auto_update = 0
command! -bar                         TlistUnlock            let tlist_auto_update = 1
command! -nargs=0 -bar                TlistRefresh           call taglist#Refresh()
command! -nargs=0 -bar                TlistOpen              call taglist#WindowOpen()
command! -nargs=0 -bar                TlistClose             call taglist#WindowClose()
command! -nargs=0 -bar                TlistToggle            call taglist#WindowToggle()
command! -nargs=+ -complete=file      TlistAddFiles          call taglist#AddFiles(<f-args>)
command! -nargs=+ -complete=dir       TlistAddFilesRecursive call taglist#AddFilesRecursive(<f-args>)
command! -nargs=0 -bar                TlistUpdate            call taglist#UpdateCurrentFile()
command! -nargs=* -complete=buffer    TlistShowPrototype     echo taglist#GetTagPrototypeByLine(<f-args>)
command! -nargs=* -complete=buffer    TlistShowTag           echo taglist#GetTagnameByLine(<f-args>)
command! -nargs=* -complete=file      TlistSessionLoad       call taglist#SessionLoad(<q-args>)
command! -nargs=* -complete=file      TlistSessionSave       call taglist#SessionSave(<q-args>)
" Commands for enabling/disabling debug and to display debug messages
command! -nargs=? -complete=file -bar TlistDebug             call taglist#DebugEnable(<q-args>)
command! -nargs=0 -bar                TlistUndebug           call taglist#DebugDisable()
command! -nargs=0 -bar                TlistMessages          call taglist#DebugShow()

" Autocommands
augroup TagListInitCmds
  autocmd!
  if g:tlist_show_menu
    autocmd GUIEnter * call taglist#MenuInit()
  endif
  if g:tlist_auto_open
    autocmd VimEnter * nested call taglist#WindowCheckAutoOpen()
  endif
  if g:tlist_process_file_always
    autocmd BufEnter,BufWritePost * call taglist#Refresh()
  endif
  " When a buffer is deleted, remove the file from the taglist
  autocmd BufDelete * silent call taglist#BufferRemoved(expand('<afile>:p'))
  " When the taglist buffer is created when loading a Vim session file,
  " the taglist buffer needs to be initialized. The BufFilePost event
  " is used to handle this case.
  autocmd BufFilePost __Tag_List__ call taglist#VimSessionLoad()
augroup END

" Restore cpotions.
let &cpo = s:cpo_save
unlet s:cpo_save
