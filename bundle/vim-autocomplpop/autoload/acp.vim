" Vim AutoComplPop
" Copyright 2007-2009 Takeshi NISHIDA
"           2016-2017 Zhen-Huan Hu

" LOAD GUARD: {{{1

if exists('g:loaded_autoload_acp') || v:version < 800
  finish
endif
let g:loaded_autoload_acp = 1

" }}}1

" Save cpoptions.
let s:cpo_save = &cpo
set cpo&vim

" GLOBAL FUNCTIONS: {{{1

" Enable auto-popup
function acp#Enable()
  augroup AcpGlobalAutoCommand
    autocmd!
    autocmd InsertEnter   * call s:ResetLastCursorPosition()
    autocmd TextChangedI  * call s:InitPopup()
    autocmd CompleteDone  * call s:CompleteDone()
    autocmd InsertLeave   * call s:RestoreOptionGroupsUpto(2)
  augroup END

  inoremap <silent> <Plug>AcpFeedPopup <C-r>=<SID>FeedPopup()<CR>
endfunction

" Disable auto-popup
function acp#Disable()
  augroup AcpGlobalAutoCommand
    autocmd!
  augroup END

  iunmap <Plug>AcpFeedPopup
endfunction

" Suspend auto-popup
function acp#Lock()
  let b:lock_count = exists('b:lock_count') ? b:lock_count + 1 : 1
endfunction

" Release auto-popup from suspension
function acp#Unlock()
  let b:lock_count = exists('b:lock_count') ? b:lock_count - 1 :
        \ throw "AutoComplPop: Not locked!"
  if b:lock_count < 1
    unlet b:lock_count
  endif
endfunction

" }}}1

" INTERNAL FUNCTIONS: {{{1

" Log debugging information
function s:LogDebugInfo(text)
  if g:acp_log_debug_info == 1
    echom "[" . s:GetCurrentText() . "] " . a:text
  endif
endfunction

" Set a temperary value to a variable
function s:SetTempOption(group, name, value)
  if !exists('s:orig_options[a:group]')
    let s:orig_options[a:group] = {}
  endif
  if !exists('s:orig_options[a:group][a:name]')
    let s:orig_options[a:group][a:name] = eval(a:name)
  endif
  execute 'let' a:name '= a:value'
endfunction

" Restore original values to a variable group
function s:RestoreTempOptions(group)
  if !exists('s:orig_options[a:group]')
    return
  endif
  for [name, value] in items(s:orig_options[a:group])
    execute 'let' name '= value'
    unlet value " To avoid E706
  endfor
  unlet s:orig_options[a:group]
endfunction

" Restore multiple variable groups
function s:RestoreOptionGroupsUpto(level)
  for group in range(0, a:level)
    call s:RestoreTempOptions(group)
  endfor
endfunction

" Retrieve contents at current line before cursor
function s:GetCurrentText()
  return strpart(getline('.'), 0, col('.') - 1)
endfunction

" Retrieve current word at cursor
" At a non-keyword character, return empty string
function s:GetCurrentWord()
  return matchstr(s:GetCurrentText(), '\k*$')
endfunction

" Reset the last cursor position
function s:ResetLastCursorPosition()
  let s:pos_last = getpos('.')
endfunction

" Check if the cursor was moved
function s:IsCursorMoved()
  if exists('s:pos_last')
    let pos_prev = s:pos_last
  endif
  call s:ResetLastCursorPosition()
  return pos_prev[1] ==# s:pos_last[1] &&
        \ abs(pos_prev[2] - s:pos_last[2]) >= 1
endfunction

" Make a new behavior set s:current_behavs
" Return 1 if a new behavior set is created, 0 if otherwise
function s:MakeCurrentBehaviorSet()
  if s:IsCursorMoved()
    let s:current_behavs = copy(exists('g:acp_behavior[&filetype]')
          \ ? g:acp_behavior[&filetype]
          \ : g:acp_behavior['*'])
  else
    return 0
  endif
  let text = s:GetCurrentText()
  call filter(s:current_behavs, 'call(v:val.meets, [text])')
  " Improve responsiveness by not to attempt another completion
  " after the last attempt failed to find any completion candidate
  if exists('s:last_word_status') && s:last_word_status.completable == 0
    if stridx(s:GetCurrentWord(), s:last_word_status.word) == 0 &&
          \ map(copy(s:current_behavs), 'v:val.command') ==# s:last_word_status.commands
      return 0
    else
      unlet! s:last_word_status
    endif
  endif
  if empty(s:current_behavs)
    return 0
  endif
  call s:LogDebugInfo("Make behavior set: [" .
        \ join(map(copy(s:current_behavs), 'v:val.command')) . "].")
  let s:behav_idx = -1
  return 1
endfunction

" Clear current behavior set s:current_behavs
function s:ClearCurrentBehaviorSet()
  let s:current_behavs = []
endfunction

" Save the status of the last word
function s:SaveLastWordStatus(completable)
  let s:last_word_status = {
        \ 'word': s:GetCurrentWord(),
        \ 'commands': map(copy(s:current_behavs), 'v:val.command'),
        \ 'completable': a:completable
        \ }
endfunction

" }}}1

" EVENT FUNCTIONS: {{{1

" Initialize popup menu
" Make behavior set and set options
function s:InitPopup()
  if (exists('b:lock_count') && b:lock_count > 0) || &paste
    return
  endif
  call s:LogDebugInfo("Initialize popup menu.")
  if s:MakeCurrentBehaviorSet()
    call s:SetTempOption(1, '&complete', g:acp_set_complete)
    call s:SetTempOption(1, '&completeopt',
          \ (g:acp_set_completeopt_preview  ? 'preview,'  : '') .
          \ (g:acp_set_completeopt_noselect ? 'noselect,' : '') .
          \ 'menuone,noinsert'
          \ )
    call s:SetTempOption(1, '&ignorecase', g:acp_set_ignorecase)
    call s:SetTempOption(1, '&lazyredraw', 1)
    call s:SetTempOption(1, '&spell', 1)
    call s:SetTempOption(2, '&textwidth', 0)
    call s:FeedPopup()
    return
  else
    call s:RestoreOptionGroupsUpto(2)
    call s:ClearCurrentBehaviorSet()
    return
  endif
endfunction

" Feed keys to trigger popup menu
function s:FeedPopup()
  if empty('s:current_behavs')
    return ''
  endif
  if pumvisible()
    call s:SaveLastWordStatus(1)
    return ''
  endif
  if s:behav_idx < len(s:current_behavs) - 1
    let s:behav_idx += 1
    " Need to update &completefunc each time
    call s:RestoreTempOptions(0)
    call s:SetTempOption(0, '&completefunc',
          \ exists('s:current_behavs[s:behav_idx].completefunc') ?
          \ s:current_behavs[s:behav_idx].completefunc :
          \ eval('&completefunc'))
    " Before initializing the next popup menu, <C-n><C-e> needs
    " to be fed first to ensure starting the first round under Insert mode
    " This is needed because a CompleteDone event will not be triggered
    " until a <C-n><C-e> is pressed
    if exists('s:last_word_status') &&
          \ s:last_word_status.completable == 1
      call feedkeys("\<C-n>\<C-e>", 'n')
      call s:LogDebugInfo("Feed keys: \<C-n>\<C-e>")
      unlet! s:last_word_status
    endif
    " After the first round, the last key command must be cancelled via <C-e>
    call feedkeys((s:behav_idx == 0 ?
          \ s:current_behavs[s:behav_idx].command :
          \ "\<C-e>" . s:current_behavs[s:behav_idx].command), 'n')
    call feedkeys("\<Plug>AcpFeedPopup")
    call s:LogDebugInfo("Feed keys: " . (s:behav_idx == 0 ?
          \ s:current_behavs[s:behav_idx].command :
          \ "\<C-e>" . s:current_behavs[s:behav_idx].command))
    return ''
  endif
  " After all attempts have failed
  call s:LogDebugInfo("All attempts failed.")
  call s:SaveLastWordStatus(0)
  call s:RestoreOptionGroupsUpto(1)
  call s:ClearCurrentBehaviorSet()
  return ''
endfunction

" Complete done
function s:CompleteDone()
  " This function is called in two scenarios
  " If completion was successful, it is executed
  " before the next InsertCharPre event; if completion
  " was aborted, it is executed after the next InsertCharPre event
  if !empty(v:completed_item)
    unlet! s:last_word_status
    call s:LogDebugInfo("Completion done.")    
    if exists('s:current_behavs[s:behav_idx].repeat')
          \ && s:current_behavs[s:behav_idx].repeat
          \ && call(s:current_behavs[s:behav_idx].meets, [s:GetCurrentText(), '0'])
      let s:current_behavs = [ s:current_behavs[s:behav_idx] ]
      let s:behav_idx = -1
      call s:FeedPopup()
      return
    endif
    if exists('s:current_behavs[s:behav_idx].closefunc')
      call call(s:current_behavs[s:behav_idx].closefunc, [])
    endif
    call s:RestoreOptionGroupsUpto(2)
    call s:ClearCurrentBehaviorSet()
    call s:ResetLastCursorPosition()
  endif
  call s:LogDebugInfo("Completion aborted.")
endfunction

" }}}1

" INITIALIZATION: {{{1

let s:behav_idx = 0
let s:current_behavs = []
let s:orig_options = {}

" }}}1

" Restore cpotions.
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set fdm=marker:
