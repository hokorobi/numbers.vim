" Palette
let s:pink     = '#f92672'
let s:orange   = '#fd971f'
let s:yellow   = '#e6db74'
let s:green    = '#a6e22e'
let s:cyan     = '#66d9ef'
let s:lavender = '#ae81ff'
let s:ash      = '#6a717c'

" First, let's define an empty dictionary and assign it to the "palette"
" variable. The # is a separator that maps with the directory structure. If
" you get this wrong, Vim will complain loudly.
let g:airline#themes#waikiki#palette = {}

" Normal mode
" First let's define some arrays. The s: is just a VimL thing for scoping the
" variables to the current script. Without this, these variables would be
" declared globally. Now let's declare some colors for normal mode and add it
" to the dictionary. The array is in the format:
" [ guifg, guibg, ctermfg, ctermbg, opts ]. See "help attr-list" for valid
" values for the "opt" value.
let s:N1 = [ '#181b20' , s:cyan , 232 , color#HexToShort(s:cyan) ] " Mode
let s:N2 = [ '#d1d5dc' , '#4b5362' , 253 , 67 ] " Info
let s:N3 = [ '#d1d5dc' , '#21252b' , 253 , 16 ] " Statusline

let g:airline#themes#waikiki#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#waikiki#palette.normal_modified = {
      \ 'airline_c': [ s:cyan , '#21252b' , color#HexToShort(s:cyan) , 16 , '' ] ,
      \ }

" Insert mode
let s:I1 = [ '#181b20' , s:green , 232 , color#HexToShort(s:green) ]
let s:I2 = [ '#d1d5dc' , '#4b5362' , 253 , 67 ]
let s:I3 = [ '#d1d5dc' , '#21252b' , 253 , 16 ]

let g:airline#themes#waikiki#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#waikiki#palette.insert_modified = {
      \ 'airline_c': [ s:green , '#21252b' , color#HexToShort(s:green) , 16 , '' ] ,
      \ }

" Replace mode
let g:airline#themes#waikiki#palette.replace = copy(g:airline#themes#waikiki#palette.insert)
let g:airline#themes#waikiki#palette.replace.airline_a = [ s:I1[0] , s:pink , s:I1[2] , color#HexToShort(s:pink) , '' ]
let g:airline#themes#waikiki#palette.replace_modified = {
      \ 'airline_c': [ s:pink , '#21252b' , color#HexToShort(s:pink) , 16 , '' ] ,
      \ }

" Visual mode
let s:V1 = [ '#181b20' , s:orange , 232 , color#HexToShort(s:orange) ]
let s:V2 = [ '#d1d5dc' , '#4b5362' , 253 , 67 ]
let s:V3 = [ '#d1d5dc' , '#21252b' , 253 , 16 ]

let g:airline#themes#waikiki#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#waikiki#palette.visual_modified = {
      \ 'airline_c': [ s:orange , '#21252b' , color#HexToShort(s:orange) , 16 , '' ] ,
      \ }

" Inactive
let s:IA = [ '#181b20' , '#4b5362' , 233 , 67 , '' ]
let g:airline#themes#waikiki#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#waikiki#palette.inactive_modified = {
      \ 'airline_c': [ '#d1d5dc' , '' , 253 , '' , '' ] ,
      \ }

" Accents are used to give parts within a section a slightly different look or
" color. Here we are defining a "red" accent, which is used by the 'readonly'
" part by default. Only the foreground colors are specified, so the background
" colors are automatically extracted from the underlying section colors. What
" this means is that regardless of which section the part is defined in, it
" will be red instead of the section's foreground color. You can also have
" multiple parts with accents within a section.
let g:airline#themes#waikiki#palette.accents = {
      \ 'red': [ s:pink , '' , color#HexToShort(s:pink) , '' , '' ],
      \ }

" CtrlP
" Here we define the color map for ctrlp. We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#waikiki#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#d1d5dc' , '#4b5362' , 253 , 67  , '' ] ,
      \ [ '#d1d5dc' , '#21252b' , 253 , 16  , '' ] ,
      \ [ '#181b20' , s:yellow , 232 , color#HexToShort(s:yellow) , 'bold' ] )
