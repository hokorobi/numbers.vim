let g:airline#themes#waikiki#palette = {}

let g:airline#themes#waikiki#palette.accents = {
      \ 'red': [ '#66D9EF' , '' , 81 , '' , '' ],
      \ }


" Normal mode
let s:N1 = [ '#181B20' , '#E6DB74' , 232 , 144 ] " mode
let s:N2 = [ '#E8EAED' , '#21252B' , 253 , 16  ] " info
let s:N3 = [ '#E8EAED' , '#4B5362' , 253 , 67  ] " statusline

let g:airline#themes#waikiki#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#waikiki#palette.normal_modified = {
      \ 'airline_c': [ '#181B20' , '#E6DB74' , 232 , 144 , '' ] ,
      \ }


" Insert mode
let s:I1 = [ '#181B20' , '#66D9EF' , 232 , 81 ]
let s:I2 = [ '#E8EAED' , '#21252B' , 253 , 16 ]
let s:I3 = [ '#E8EAED' , '#4B5362' , 253 , 67 ]

let g:airline#themes#waikiki#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#waikiki#palette.insert_modified = {
      \ 'airline_c': [ '#181B20' , '#66D9EF' , 232 , 81 , '' ] ,
      \ }


" Replace mode
let g:airline#themes#waikiki#palette.replace = copy(g:airline#themes#waikiki#palette.insert)
let g:airline#themes#waikiki#palette.replace.airline_a = [ s:I1[0]   , '#ef5939' , s:I1[2] , 166     , ''     ]
let g:airline#themes#waikiki#palette.replace_modified = {
      \ 'airline_c': [ '#181B20' , '#F92672' , 232 , 166 , '' ] ,
      \ }


" Visual mode
let s:V1 = [ '#181B20' , '#FD971F' , 232 , 208 ]
let s:V2 = [ '#E8EAED' , '#21252B' , 253 , 16  ]
let s:V3 = [ '#E8EAED' , '#4B5362' , 253 , 67  ]

let g:airline#themes#waikiki#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#waikiki#palette.visual_modified = {
      \ 'airline_c': [ '#181B20' , '#FD971F' , 232 , 208 , '' ] ,
      \ }


" Inactive
let s:IA = [ '#181B20' , '#4B5362' , 233 , 67 , '' ]
let g:airline#themes#waikiki#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#waikiki#palette.inactive_modified = {
      \ 'airline_c': [ '#E8EAED' , ''        , 253 , ''  , '' ] ,
      \ }


" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#waikiki#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ '#E8EAED' , '#4B5362' , 253 , 67  , ''     ] ,
      \ [ '#E8EAED' , '#21252B' , 253 , 16  , ''     ] ,
      \ [ '#181B20' , '#E6DB74' , 232 , 144 , 'bold' ] )

