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
    autocmd InsertEnter  * call s:ResetLastCursorPosition()
    autocmd TextChangedI * call s:InitPopup()
    autocmd CompleteDone * call s:CompleteDone()
    autocmd InsertLeave  * call s:FinishPopup(2)
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

" Default completion function for snipMate
function acp#CompleteFuncForSnipmate(findstart, base)
  if a:findstart
    let pos = matchstrpos(s:GetCurrentText(), '\S\+$')[1]
    return pos >= 0 ? pos : -3
  endif
  let base = type(a:base) == v:t_number ? string(a:base) : a:base
  let items = filter(GetSnipsInCurrentScope(),
        \ 'strpart(v:key, 0, len(base)) ==? base')
  return map(sort(items(items)), 's:MakeSnipmateItems(v:val[0], v:val[1])')
endfunction

" }}}1

" LOCAL FUNCTIONS: {{{1

" Create snipMate item list for the complete function
function s:MakeSnipmateItems(key, snip)
  return {
        \ 'word': a:key,
        \ 'menu': strpart((type(a:snip) == v:t_list ?
        \         '[' . len(a:snip) . '] ' . join(map(copy(a:snip), 'v:val[0]'), ', ') :
        \         substitute(a:snip, '\(\n\|\s\)\+', ' ', 'g')
        \         ), 0, 80),
        \ }
endfunction

" Default close function for snipMate
function s:CloseFuncForSnipmate()
  let match = matchstr(s:GetCurrentText(), '\S\+$')
  for trigger in keys(GetSnipsInCurrentScope())
    if match ==# trigger
      call feedkeys("\<C-r>=TriggerSnippet()\<CR>", 'n')
      return 1
    endif
  endfor
  return 0
endfunction

" Default 'meets' function for snipMate
" to determine whether to attempt a completion
function s:MeetsForSnipmate(context, ...)
  if g:acp_snipmate_length < 0
    return 0
  endif
  let match = matchstr(a:context, '\S\{' . g:acp_snipmate_length . ',}$')
  if len(match) == 0
    return 0
  endif
  let key = match
  if !exists('s:snip_items[key]')
    let s:snip_items[key] = items(GetSnipsInCurrentScope())
    call filter(s:snip_items[key], 'strpart(v:val[0], 0, len(match)) ==? match')
    call map(s:snip_items[key], 's:MakeSnipmateItems(v:val[0], v:val[1])')
  endif
  return !empty('s:snip_items[key]')
endfunction

" Default 'meets' function for anything that is a keyword
" to determine whether to attempt a completion
function s:MeetsForKeyword(context, ...)
  if g:acp_keyword_length < 0
    return 0
  endif
  let match = matchstr(a:context, '\k\{' . g:acp_keyword_length . ',}$')
  if len(match) == 0
    return 0
  endif
  for ignored in g:acp_keyword_ignored
    " Do not attempt a completion
    " if the start of a match occurs in 'ignored'
    if stridx(ignored, match) == 0
      return 0
    endif
  endfor
  return 1
endfunction

" Default 'meets' function for file names
" to determine whether to attempt a completion
function s:MeetsForFile(context, ...)
  if g:acp_file_length < 0
    return 0
  endif
  let sep = (has('win32') || has('win64')) ? '[/\\]' : '\/'
  if a:0 > 0 ?
        \ a:context !~ '\f' . sep . '\f\{' . a:1 . '}$' :
        \ a:context !~ '\f' . sep . '\f\{' . g:acp_file_length . ',}$'
    return 0
  endif
  return a:context !~ '[*/\\][/\\]\f*$\|[^[:print:]]\f*$'
endfunction

" Default 'meets' function for texts
" to determine whether to attempt a spelling completion
function s:MeetsForText(context, ...)
  return g:acp_text_length >= 0 &&
        \ a:context =~ '\w\{' . g:acp_text_length . ',}$'
endfunction

" Default 'meets' function for VimScript
" to determine whether to attempt a completion
function s:MeetsForVimScript(context, ...)
  return g:acp_vimscript_length >= 0 &&
        \ a:context =~ '\k\{' . g:acp_vimscript_length . ',}$'
endfunction

" Default 'meets' function for Ruby
" to determine whether to attempt a completion
function s:MeetsForRubyOmni(context, ...)
  return has('ruby') &&
        \ (g:acp_ruby_omni_method_length >= 0 &&
        \ a:context =~ '\k\(\.\|::\)\k\{' . g:acp_ruby_omni_method_length . ',}$') ||
        \ (g:acp_ruby_omni_symbol_length >= 0 &&
        \ a:context =~ '\(^\|[^:]\):\k\{' . g:acp_ruby_omni_symbol_length . ',}$')
endfunction

" Default 'meets' function for Python
" to determine whether to attempt a completion
function s:MeetsForPythonOmni(context, ...)
  return has('python') && g:acp_python_omni_length >= 0 &&
        \ a:0 > 0 ?
        \ a:context =~ '\k\.\k\{' . a:1 . '}$' :
        \ a:context =~ '\k\.\k\{' . g:acp_python_omni_length . ',}$'
endfunction

" Default 'meets' function for Perl
" to determine whether to attempt a completion
function s:MeetsForPerlOmni(context, ...)
  return has('perl') && g:acp_perl_omni_length >= 0 &&
        \ a:context =~ '\w->\k\{' . g:acp_perl_omni_length . ',}$'
endfunction

" Default 'meets' function for Xml
" to determine whether to attempt a completion
function s:MeetsForXmlOmni(context, ...)
  return g:acp_xml_omni_length >= 0 &&
        \ a:context =~ '<\(\/\=\|[^>]\+ \)\k\{' . g:acp_xml_omni_length . ',}$'
endfunction

" Default 'meets' function for Html
" to determine whether to attempt a completion
function s:MeetsForHtmlOmni(context, ...)
  return g:acp_html_omni_length >= 0 &&
        \ a:context =~ '<\(\/\=\|[^>]\+ \)\k\{' . g:acp_html_omni_length . ',}$'
endfunction

" Default 'meets' function for Css
" to determine whether to attempt a completion
function s:MeetsForCssOmni(context, ...)
  return (g:acp_css_omni_property_length >= 0 &&
        \ a:context =~ '\(^\|[;{]\)\s*\k\{' . g:acp_css_omni_property_length . ',}$') ||
        \ (g:acp_css_omni_value_length >= 0 &&
        \ a:context =~ '[:@!]\s*\k\{' . g:acp_css_omni_value_length . ',}$')
endfunction

" Default 'meets' function for JavaScript
" to determine whether to attempt a completion
function s:MeetsForJavaScriptOmni(context, ...)
  return g:acp_javascript_omni_length >= 0 &&
        \ a:context =~ '\k\.\k\{' . g:acp_javascript_omni_length . ',}$'
endfunction

" Default 'meets' function for Php
" to determine whether to attempt a completion
function s:MeetsForPhpOmni(context, ...)
  return g:acp_php_omni_length >= 0 &&
        \ a:context =~ '\w\(->\|::\)\k\{' . g:acp_php_omni_length . ',}$'
endfunction

" Default 'meets' function for SAS
" to determine whether to attempt a completion
function s:MeetsForSASOmni(context, ...)
  return g:acp_sas_omni_length >= 0 &&
        \ a:context =~ '\<proc\s\+\k\{' . g:acp_sas_omni_length . ',}$'
endfunction

" Set variable with temporary value
function s:SetTempOption(group, name, value)
  if !exists('s:orig_options[a:group]')
    let s:orig_options[a:group] = {}
  endif
  if !exists('s:orig_options[a:group][a:name]')
    let s:orig_options[a:group][a:name] = eval(a:name)
  endif
  execute 'let' a:name '= a:value'
endfunction

" Restore original value to variable and clean up
function s:RestoreTempOptions(group)
  if !exists('s:orig_options[a:group]')
    return
  endif
  for [name, value] in items(s:orig_options[a:group])
    execute 'let' name '= value'
    unlet value " to avoid E706
  endfor
  unlet s:orig_options[a:group]
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

" Clear current behavior set s:current_behavs
function s:ClearCurrentBehaviorSet()
  let s:current_behavs = []
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

" Initialize
function s:InitPopup()
  if (exists('b:lock_count') && b:lock_count > 0) || &paste
    return
  endif
  call s:LogDebugInfo("Initialize popup.")
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
    call s:FinishPopup(2)
    call s:ClearCurrentBehaviorSet()
    return
  endif
endfunction

" Save the status of the last word
function s:SaveLastWordStatus(completable)
  let s:last_word_status = {
      \ 'word': s:GetCurrentWord(),
      \ 'commands': map(copy(s:current_behavs), 'v:val.command'),
      \ 'completable': a:completable
      \ }
endfunction

" Feed keys to trigger popup menu
function s:FeedPopup()
  if !exists('s:current_behavs[s:behav_idx]')
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
    " Before feeding the first key command, <C-n><C-e> needs
    " to be fed first to ensure starting the first round under Insert mode.
    " After the first round, the last key command must be cancelled via <C-e>
    call s:LogDebugInfo("Feed keys: " . (s:behav_idx == 0 ?
          \ s:current_behavs[s:behav_idx].command :
          \ "\<C-e>" . s:current_behavs[s:behav_idx].command))
    call feedkeys((s:behav_idx == 0 &&
          \ exists('s:last_word_status') &&
          \ s:last_word_status.completable == 1 ?
          \ "\<C-n>\<C-e>" : ''), 'n')
    call feedkeys((s:behav_idx == 0 ?
          \ s:current_behavs[s:behav_idx].command :
          \ "\<C-e>" . s:current_behavs[s:behav_idx].command), 'n')
    call feedkeys("\<Plug>AcpFeedPopup")
    return ''
  endif
  " After all attempts have failed
  call s:LogDebugInfo("All attempts failed.")
  call feedkeys("\<C-e>", 'n')
  call s:SaveLastWordStatus(0)
  call s:FinishPopup(1)
  call s:ClearCurrentBehaviorSet()
  return ''
endfunction

" Complete done
function s:CompleteDone()
  " This function is called in two scenarios
  " If completion was successful, it is executed
  " before the next s:InitPopup() call; if completion
  " failed, it is executed after the next s:InitPopup()
  if !empty(v:completed_item)
    call s:LogDebugInfo("Completion done.")
    unlet! s:last_word_status
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
    call s:FinishPopup(2)
    call s:ClearCurrentBehaviorSet()
    call s:ResetLastCursorPosition()
  endif
  call s:LogDebugInfo("Completion failed.")
endfunction

" Finish up
function s:FinishPopup(level)
  for level_group in range(0, a:level)
    call s:RestoreTempOptions(level_group)
  endfor
endfunction

" Log debugging information
function s:LogDebugInfo(text)
  if g:acp_log_debug_info == 1
    echom "[" . s:GetCurrentText() . "] " . a:text
  endif
endfunction

" }}}1

" INITIALIZATION: {{{1

let s:behav_idx = 0
let s:current_behavs = []
let s:orig_options = {}
let s:snip_items = {}

" }}}1

" Restore cpotions.
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set fdm=marker:
