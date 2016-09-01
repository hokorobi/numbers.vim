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
        \ "guifg=" . a:fg[0]
        \ "guibg=" . a:bg[0]
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
  if &t_Co > 255
    execute "hi" a:name
          \ "ctermfg=" . a:fg[1]
          \ "ctermbg=" . a:bg[1]
          \ "cterm=" . (a:0 > 0 ? a:1 : "NONE")
  end
endf

fu! s:SetFgColor(name, fg, ...)
  execute "hi" a:name
        \ "guifg=" . a:fg[0]
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
  if &t_Co > 255
    execute "hi" a:name
          \ "ctermfg=" . a:fg[1]
          \ "cterm=" . (a:0 > 0 ? a:1 : "NONE")
  end
endf

fu! s:SetBgColor(name, bg, ...)
  execute "hi" a:name
        \ "guibg=" . a:bg[0]
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
  if &t_Co > 255
    execute "hi" a:name
          \ "ctermbg=" . a:bg[1]
          \ "cterm=" . (a:0 > 0 ? a:1 : "NONE")
  end
endf

fu! s:SetSpColor(name, sp)
  execute "hi" a:name
        \ "guisp=" . a:sp[0]
        \ "gui=undercurl"
  if &t_Co > 255
    execute "hi" a:name
          \ "ctermfg=bg"
          \ "ctermbg=" . a:sp[1]
  end
endf
" }}}

" Palette
let s:uih = 220 " Hue
let s:uis = 13  " Saturation
let s:uil = 18  " Lightness

let s:fg = [color#HSLtoHex(s:uih, min([s:uis, 18]), max([s:uil * 3, 66])), 248] " #9DA5B4
let s:bg = [color#HSLtoHex(s:uih, s:uis, s:uil)                          , 236] " #282C34

let s:light = [color#Lighten(s:fg, 28), 252] " #D1D5DC
let s:grey1 = [color#Lighten(s:fg, 8 ), 249] " #ABB2BF
let s:grey2 = s:fg                           " #9DA5B4
let s:grey3 = [ color#Darken(s:fg, 48), 240] " #4B5362
let s:grey4 = [color#Lighten(s:bg, 48), 238] " #3C424E
let s:dark1 = [color#Lighten(s:bg, 28), 237] " #333842
let s:dark2 = s:bg                           " #282C34
let s:dark3 = [ color#Darken(s:bg, 16), 235] " #21252B
let s:black = [ color#Darken(s:bg, 40), 234] " #181B20

let s:pink      = ['#F92672', 161]
let s:orange    = ['#FD971F', 208]
let s:yellow    = ['#E6DB74', 227]
let s:green     = ['#A6E22E', 118]
let s:cyan      = ['#66D9EF', 81 ]
let s:lavender  = ['#AE81FF', 141]
let s:ash       = ['#6A717C', 242]

let s:bgpink    = [color#HSLtoHex(color#HexToHSL(s:pink  )[0], s:uis, s:uil), 52 ]
let s:bgorange  = [color#HSLtoHex(color#HexToHSL(s:orange)[0], s:uis, s:uil), 94 ]
let s:bgyellow  = [color#HSLtoHex(color#HexToHSL(s:yellow)[0], s:uis, s:uil), 100]
let s:bggreen   = [color#HSLtoHex(color#HexToHSL(s:green )[0], s:uis, s:uil), 22 ]

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
  call s:SetSpColor("SpellBad", s:pink)
  call s:SetSpColor("SpellCap", s:lavender)
  call s:SetSpColor("SpellLocal", s:lavender)
  call s:SetSpColor("SpellRare", s:light)
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

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
