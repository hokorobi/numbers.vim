" Internal function
fu! s:ColorExpand(fg, bg)
  let fg = (len(a:fg) > 0 ? [a:fg, color#HexToShort(a:fg)] : ['', ''])
  let bg = (len(a:bg) > 0 ? [a:bg, color#HexToShort(a:bg)] : ['', ''])
  return [fg[0], bg[0], fg[1], bg[1]]
endf

" Palette
let s:pink     = '#b73999'
let s:red      = '#dc3c3c'
let s:yellow   = '#d28e5d'
let s:mint     = '#95c76f'
let s:green    = '#52bd58'
let s:cyan     = '#4670d8'
let s:lavender = '#8485ce'
let s:ash      = '#64878f'

" First, let's define an empty dictionary and assign it to the "palette"
" variable. The # is a separator that maps with the directory structure. If
" you get this wrong, Vim will complain loudly.
let g:airline#themes#wwdc16#palette = {}

" Normal mode
" First let's define some arrays. The s: is just a VimL thing for scoping the
" variables to the current script. Without this, these variables would be
" declared globally. Now let's declare some colors for normal mode and add it
" to the dictionary. The array is in the format:
" [ guifg, guibg, ctermfg, ctermbg, opts ]. See "help attr-list" for valid
" values for the "opt" value.
let s:N1 = s:ColorExpand('#181b20', s:cyan   ) " Mode
let s:N2 = s:ColorExpand('#d1d5dc', '#4b5362') " Info
let s:N3 = s:ColorExpand('#d1d5dc', '#21252b') " Statusline

let g:airline#themes#wwdc16#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#wwdc16#palette.normal_modified = {
      \ 'airline_c': s:ColorExpand(s:cyan, '#21252b'),
      \ }

" Insert mode
let s:I1 = s:ColorExpand('#181b20', s:green  )
let s:I2 = s:ColorExpand('#d1d5dc', '#4b5362')
let s:I3 = s:ColorExpand('#d1d5dc', '#21252b')

let g:airline#themes#wwdc16#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#wwdc16#palette.insert_modified = {
      \ 'airline_c': s:ColorExpand(s:green, '#21252b'),
      \ }

" Replace mode
let g:airline#themes#wwdc16#palette.replace = copy(g:airline#themes#wwdc16#palette.insert)
let g:airline#themes#wwdc16#palette.replace.airline_a = s:ColorExpand(s:I1[0], s:pink)
let g:airline#themes#wwdc16#palette.replace_modified = {
      \ 'airline_c': s:ColorExpand(s:pink, '#21252b'),
      \ }

" Visual mode
let s:V1 = s:ColorExpand('#181b20', s:yellow )
let s:V2 = s:ColorExpand('#d1d5dc', '#4b5362')
let s:V3 = s:ColorExpand('#d1d5dc', '#21252b')

let g:airline#themes#wwdc16#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#wwdc16#palette.visual_modified = {
      \ 'airline_c': s:ColorExpand(s:yellow, '#21252b'),
      \ }

" Inactive
let s:IA = s:ColorExpand('#181b20', '#4b5362')
let g:airline#themes#wwdc16#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#wwdc16#palette.inactive_modified = {
      \ 'airline_c': s:ColorExpand('#d1d5dc', ''),
      \ }

" Accents are used to give parts within a section a slightly different look or
" color. Here we are defining a "red" accent, which is used by the 'readonly'
" part by default. Only the foreground colors are specified, so the background
" colors are automatically extracted from the underlying section colors. What
" this means is that regardless of which section the part is defined in, it
" will be red instead of the section's foreground color. You can also have
" multiple parts with accents within a section.
let g:airline#themes#wwdc16#palette.accents = {
      \ 'red': s:ColorExpand(s:red, ''),
      \ }

" CtrlP
" Here we define the color map for ctrlp. We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#wwdc16#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ s:ColorExpand('#181b20', s:lavender) + ['bold'],
      \ s:ColorExpand('#d1d5dc', '#4b5362'),
      \ s:ColorExpand('#d1d5dc', '#21252b'))
