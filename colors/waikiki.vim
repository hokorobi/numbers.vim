" Vim color file
"
" Author: Zhenhuan Hu <zhu@mcw.edu>
"
" Note: Based on the Monokai theme for TextMate
" by Wimer Hazenberg and its darker variant
" by Hamish Stuart Macpherson
" And OneDark theme for the UI colors

" Initialization {{{
if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name="waikiki"
" }}}

" Functions {{{
fu! s:SetColor(name, fg, bg, ...)
  execute "hi" a:name
        \ "guifg=" . a:fg
        \ "guibg=" . a:bg
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
endf

fu! s:SetFgColor(name, color, ...)
  execute "hi" a:name
        \ "guifg=" . a:color
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
endf

fu! s:SetBgColor(name, color, ...)
  execute "hi" a:name
        \ "guibg=" . a:color
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
endf

fu! s:SetSpColor(name, color, ...)
  execute "hi" a:name
        \ "guisp=" . a:color
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
endf
" }}}

" Palette
let s:uih = 220 " Hue
let s:uis = 13  " Saturation
let s:uil = 18  " Lightness

let s:fg = color#HSLtoHex(s:uih, min([s:uis, 18]), max([s:uil * 3, 66]))  " #9DA5B4
let s:bg = color#HSLtoHex(s:uih, s:uis, s:uil)                            " #282C34

let s:light = color#Lighten(s:fg, 28) " #D1D5DC
let s:grey1 = color#Lighten(s:fg, 8)  " #ABB2BF
let s:grey2 = s:fg                    " #9DA5B4
let s:grey3 = color#Darken(s:fg, 48)  " #4B5362 
let s:grey4 = color#Lighten(s:bg, 48) " #3C424E
let s:dark1 = color#Lighten(s:bg, 28) " #333842
let s:dark2 = s:bg                    " #282C34
let s:dark3 = color#Darken(s:bg, 16)  " #21252B
let s:black = color#Darken(s:bg, 40)  " #181B20

let s:pink      = '#F92672'
let s:orange    = '#FD971F'
let s:yellow    = '#E6DB74'
let s:green     = '#A6E22E'
let s:cyan      = '#66D9EF'
let s:lavender  = '#AE81FF'
let s:ash       = '#6A717C'

let s:bgpink    = color#HSLtoHex(color#HexToHSL(s:pink)[0], s:uis, s:uil)
let s:bgorange  = color#HSLtoHex(color#HexToHSL(s:orange)[0], s:uis, s:uil)
let s:bgyellow  = color#HSLtoHex(color#HexToHSL(s:yellow)[0], s:uis, s:uil)
let s:bggreen   = color#HSLtoHex(color#HexToHSL(s:green)[0], s:uis, s:uil)

call s:SetColor("Normal", s:light, s:bg)
call s:SetColor("Cursor", s:black, s:light)
call s:SetBgColor("CursorLine", s:dark1)
call s:SetBgColor("CursorColumn", s:dark1)
call s:SetBgColor("Visual", s:grey4)
call s:SetBgColor("VisualNOS", s:grey4)
call s:SetBgColor("ColorColumn", s:dark3)
call s:SetColor("SignColumn", s:green, s:dark3)
call s:SetColor("LineNr", s:grey3, s:dark3)
call s:SetFgColor("CursorLineNr", s:orange)
call s:SetColor("VertSplit", s:grey3, s:dark3)
call s:SetColor("FoldColumn", s:grey3, s:dark3)
call s:SetColor("Folded", s:fg, s:black)
call s:SetColor("MatchParen", s:black, s:orange, "bold")
call s:SetColor("Pmenu", s:black, s:fg)
call s:SetColor("PmenuSel", s:black, s:cyan)
call s:SetBgColor("PmenuSbar", s:dark3)
call s:SetFgColor("PmenuThumb", s:cyan)
call s:SetColor("TabLine", s:fg, s:black)
call s:SetColor("TabLineFill", s:black, s:black)
call s:SetColor("TabLineSel", s:black, s:fg)
call s:SetColor("StatusLine", s:black, s:fg)
call s:SetColor("StatusLineNC", s:fg, s:black)
call s:SetColor("WildMenu", s:black, s:cyan)
call s:SetColor("IncSearch", s:black, s:cyan)
call s:SetColor("Search", s:black, s:orange)
call s:SetFgColor("NonText", s:grey3)
call s:SetFgColor("SpecialKey", s:grey3, "italic")
call s:SetFgColor("Title", s:green, "bold")
call s:SetFgColor("Directory", s:green, "bold")
call s:SetFgColor("Question", s:cyan, "bold")
call s:SetFgColor("ErrorMsg", s:pink, "bold")
call s:SetFgColor("ModeMsg", s:yellow, "bold")
call s:SetFgColor("MoreMsg", s:yellow, "bold")
call s:SetFgColor("WarningMsg", s:orange, "bold")
call s:SetColor("DiffAdd", s:fg, s:bggreen)
call s:SetColor("DiffDelete", s:fg, s:bgpink)
call s:SetColor("DiffChange", s:fg, s:bgyellow)
call s:SetColor("DiffText", s:orange, s:bgyellow)

if has("spell")
  call s:SetSpColor("SpellBad", s:pink, "undercurl")
  call s:SetSpColor("SpellCap", s:lavender, "undercurl")
  call s:SetSpColor("SpellLocal", s:lavender, "undercurl")
  call s:SetSpColor("SpellRare", s:light, "undercurl")
endif

" Comment
call s:SetFgColor("Comment", s:ash, "italic")
" Constant
call s:SetFgColor("Boolean", s:lavender)
call s:SetFgColor("Character", s:yellow)
call s:SetFgColor("Constant", s:lavender)
call s:SetFgColor("Float", s:lavender)
call s:SetFgColor("Number", s:lavender)
call s:SetFgColor("String", s:yellow)
" Identifier
call s:SetFgColor("Function", s:green)
call s:SetFgColor("Identifier", s:orange)
" Statement
call s:SetFgColor("Conditional", s:pink, "bold")
call s:SetFgColor("Exception", s:pink, "bold")
call s:SetFgColor("Keyword", s:pink, "bold")
call s:SetFgColor("Label", s:yellow, "italic")
call s:SetFgColor("Operator", s:pink)
call s:SetFgColor("Repeat", s:pink, "bold")
call s:SetFgColor("Statement", s:pink, "bold")
" Preprocessor
call s:SetFgColor("Define", s:cyan)
call s:SetFgColor("Include", s:cyan)
call s:SetFgColor("Macro", s:cyan, "italic")
call s:SetFgColor("PreCondit", s:green, "bold")
call s:SetFgColor("PreProc", s:green)
" Type
call s:SetFgColor("StorageClass", s:orange, "italic")
call s:SetFgColor("Structure", s:cyan)
call s:SetFgColor("Type", s:cyan)
call s:SetFgColor("Typedef", s:cyan)
" Special
call s:SetFgColor("Delimiter", s:orange, "bold")
call s:SetFgColor("Debug", s:green, "italic")
call s:SetFgColor("Special", s:cyan, "italic")
call s:SetFgColor("SpecialChar", s:lavender, "italic")
call s:SetFgColor("SpecialComment", s:ash, "bold,italic")
call s:SetFgColor("Tag", s:pink, "italic")
" Other
call s:SetFgColor("Error", s:pink, "undercurl")
call s:SetFgColor("Ignore", s:ash)
call s:SetFgColor("Todo", s:ash, "bold,italic")
call s:SetFgColor("Underlined", s:ash, "underline")

" Support for 256-color terminal
" This part was copied from molokai color scheme
if &t_Co > 255
  hi Normal          ctermfg=252 ctermbg=233
  hi CursorLine                  ctermbg=234   cterm=none
  hi CursorLineNr    ctermfg=208               cterm=none
  hi Boolean         ctermfg=135
  hi Character       ctermfg=144
  hi Number          ctermfg=135
  hi String          ctermfg=144
  hi Conditional     ctermfg=161               cterm=bold
  hi Constant        ctermfg=135               cterm=bold
  hi Cursor          ctermfg=16  ctermbg=253
  hi Debug           ctermfg=225               cterm=bold
  hi Define          ctermfg=81
  hi Delimiter       ctermfg=241

  hi DiffAdd                     ctermbg=24
  hi DiffChange      ctermfg=181 ctermbg=239
  hi DiffDelete      ctermfg=162 ctermbg=53
  hi DiffText                    ctermbg=102   cterm=bold

  hi Directory       ctermfg=118               cterm=bold
  hi Error           ctermfg=219 ctermbg=89
  hi ErrorMsg        ctermfg=199 ctermbg=16    cterm=bold
  hi Exception       ctermfg=118               cterm=bold
  hi Float           ctermfg=135
  hi FoldColumn      ctermfg=67  ctermbg=16
  hi Folded          ctermfg=67  ctermbg=16
  hi Function        ctermfg=118
  hi Identifier      ctermfg=208               cterm=none
  hi Ignore          ctermfg=244 ctermbg=232
  hi IncSearch       ctermfg=193 ctermbg=16

  hi keyword         ctermfg=161               cterm=bold
  hi Label           ctermfg=229               cterm=none
  hi Macro           ctermfg=193
  hi SpecialKey      ctermfg=81

  hi MatchParen      ctermfg=233 ctermbg=208   cterm=bold
  hi ModeMsg         ctermfg=229
  hi MoreMsg         ctermfg=229
  hi Operator        ctermfg=161

  " Complete menu
  hi Pmenu           ctermfg=81  ctermbg=16
  hi PmenuSel        ctermfg=255 ctermbg=242
  hi PmenuSbar                   ctermbg=232
  hi PmenuThumb      ctermfg=81

  hi PreCondit       ctermfg=118               cterm=bold
  hi PreProc         ctermfg=118
  hi Question        ctermfg=81
  hi Repeat          ctermfg=161               cterm=bold
  hi Search          ctermfg=0   ctermbg=222   cterm=NONE

  " Marks column
  hi SignColumn      ctermfg=118 ctermbg=235
  hi SpecialChar     ctermfg=161               cterm=bold
  hi SpecialComment  ctermfg=245               cterm=bold
  hi Special         ctermfg=81
  
  if has("spell")
    hi SpellBad                  ctermbg=52
    hi SpellCap                  ctermbg=17
    hi SpellLocal                ctermbg=17
    hi SpellRare    ctermfg=none ctermbg=none  cterm=reverse
  endif
  
  hi Statement       ctermfg=161               cterm=bold
  hi StatusLine      ctermfg=238 ctermbg=253
  hi StatusLineNC    ctermfg=244 ctermbg=232
  hi StorageClass    ctermfg=208
  hi Structure       ctermfg=81
  hi Tag             ctermfg=161
  hi Title           ctermfg=166
  hi Todo            ctermfg=231 ctermbg=232   cterm=bold

  hi Typedef         ctermfg=81
  hi Type            ctermfg=81                cterm=none
  hi Underlined      ctermfg=244               cterm=underline

  hi VertSplit       ctermfg=244 ctermbg=232   cterm=bold
  hi VisualNOS                   ctermbg=238
  hi Visual                      ctermbg=235
  hi WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
  hi WildMenu        ctermfg=81  ctermbg=16

  hi Comment         ctermfg=59
  hi CursorColumn                ctermbg=236
  hi ColorColumn                 ctermbg=236
  hi LineNr          ctermfg=250 ctermbg=236
  hi NonText         ctermfg=59

  hi SpecialKey      ctermfg=59
end

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
