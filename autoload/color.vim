" File: color.vim
" Author: Zhenhuan Hu <https://github.com/akanosora>
" Date: Aug 31, 2016
" License: GPL
" Description: vimscript RGB/HSL color parsing
" Based on romgrk's vimscript for color parsing

" Definitions: {{{1

" In function names:
" - 'Hex' refers to hexadecimal color format e.g. #599eff
" - 'RGB' refers to an array of integers [r, g, b]
"   where r, g, b in the set [0, 255]
" - 'HSL' refers to an array of [h, s, l]
"   where h in the set [0, 360], s, l in the set [0, 100]
" color-format patterns:
let s:patterns = {}
let s:patterns['hex']      = '\v#?(\x{2})(\x{2})(\x{2})'
let s:patterns['shortHex'] = '\v#(\x{1})(\x{1})(\x{1})' " Short version is more strict: starting # mandatory
"let s:patterns['rgb']  = '\vrgb\s*\((\d+)\s*,(\d+)\s*,(\d+)\s*)\s*'
"let s:patterns['rgba'] = '\vrgba\s*\((\d+)\s*,(\d+)\s*,(\d+)\s*,(\d+)\s*)\s*'

" Functions: {{{1

" @params  String       string   The string to test
" @returns Boolean     [0 or 1]  if string matches: rrggbb OR #rrggbb OR #rgb
fu! color#Test (string)
  for key in keys(s:patterns)
    if a:string =~# s:patterns[key]
      return 1
    end
  endfor
  return 0
endfu

" @params (r, g, b|[r, g, b])
" @returns String       A RGB color
fu! color#RGBtoHex (...)
  let [r, g, b] = ( a:0 == 1 ? a:1 : a:000 )
  let num = printf('%02x', r)
        \ . printf('%02x', g)
        \ . printf('%02x', b)
  return '#' . num
endfu

" @param {String|Number} color
fu! color#HexToRGB (color)
  if type(a:color) == 2
    let color = printf('%x', a:color)
  else
    let color = a:color | end

  let matches = matchlist(color, s:patterns['hex'])
  let factor  = 0x1

  if empty(matches)
    let matches = matchlist(color, s:patterns['shortHex'])
    let factor  = 0x10
  end

  if len(matches) < 4
    echohl Error
    echom 'Could not parse ' . string(color) . ' ' .  string(matches)
    echohl None
    return | end

  let r = str2nr(matches[1], 16) * factor
  let g = str2nr(matches[2], 16) * factor
  let b = str2nr(matches[3], 16) * factor

  return [r, g, b]
endfu

" Converts an HSL color value to RGB. Conversion formula
" adapted from http://en.wikipedia.org/wiki/HSL_color_space.
" Assumes h is in the set [0, 360],
" s and l are contained in the set [0, 100],
" and returns r, g, and b in the set [0, 255].
" @param   Number  h     OR     @param  Array [h, s, l]
" @param   Number  s
" @param   Number  l
" @returns Array [r, g, b]     The RGB representation
fu! color#HSLtoRGB(...) " (h, s, l)
  let [h, s, l] = ( a:0 == 1 ? a:1 : a:000 )

  if s == 0 " Achromatic
    let r = float2nr(round(l * 2.55))
    let g = float2nr(round(l * 2.55))
    let b = float2nr(round(l * 2.55))
  else
    let hf = h / 60.0
    let c = (100 - abs(2 * l - 100)) * s / 100.0
    let x = c * (1 - abs(hf - float2nr(hf) + float2nr(hf) % 2 - 1))
    if hf >= 0.0 && hf < 1.0
      let rf = c * 2.55 | let gf = x * 2.55 | let bf = 0.0
    elseif hf >= 1.0 && hf < 2.0
      let rf = x * 2.55 | let gf = c * 2.55 | let bf = 0.0
    elseif hf >= 2.0 && hf < 3.0
      let rf = 0.0 | let gf = c * 2.55 | let bf = x * 2.55
    elseif hf >= 3.0 && hf < 4.0
      let rf = 0.0 | let gf = x * 2.55 | let bf = c * 2.55
    elseif hf >= 4.0 && hf < 5.0
      let rf = x * 2.55 | let gf = 0.0 | let bf = c * 2.55
    elseif hf >= 5.0 && hf < 6.0
      let rf = c * 2.55 | let gf = 0.0 | let bf = x * 2.55
    end
    let m = l - 0.5 * c
    let r = float2nr(round(rf + m * 2.55))
    let g = float2nr(round(gf + m * 2.55))
    let b = float2nr(round(bf + m * 2.55))
  end

  return [r, g, b]
endfu

" Converts an RGB color value to HSV. Conversion formula
" adapted from http://en.wikipedia.org/wiki/HSV_color_space.
" Assumes r, g, and b are contained in the set [0, 255],
" and returns h in the set [0, 360],
" s and v in the set [0, 100].
" @param   Number  r     OR     @param  Array [r, g, b]
" @param   Number  g
" @param   Number  b
" @returns Array [h, s, l]     The HSL representation
fu! color#RGBtoHSL(...)
  let [r, g, b] = ( a:0 == 1 ? a:1 : a:000 )

  let max = max([r, g, b]) / 255.0
  let min = min([r, g, b]) / 255.0
  let r = r / 255.0
  let g = g / 255.0
  let b = b / 255.0

  let lf = (max + min) / 2.0
  if max == min
    let hf = 0.0 " Achromatic
    let sf = 0.0 " Achromatic
  else
    let c = max - min
    if max == r
      let hf = (g - b) / c + (g < b ? 6.0 : 0.0)
    elseif max == g
      let hf = (b - r) / c + 2.0
    elseif max == b
      let hf = (r - g) / c + 4.0
    end
    let sf = c / (1.0 - abs(2.0 * lf - 1))
  end

  let h = float2nr(round(hf * 60))
  let s = float2nr(round(sf * 100))
  let l = float2nr(round(lf * 100))

  return [h, s, l]
endfu

" Composed functions:
fu! color#HexToHSL (color)
  let [r, g, b] = color#HexToRGB(a:color)
  return color#RGBtoHSL(r, g, b)
endfu

fu! color#HSLtoHex (...)
  let [h, s, l] = ( a:0 == 1 ? a:1 : a:000 )
  let [r, g, b] = color#HSLtoRGB(h, s, l)
  return color#RGBtoHex(r, g, b)
endfu

" @params String                 color      The color
" @params {Number|String|Float} [amount=5]  The percentage of light
fu! color#Lighten(color, ...)
  let amount = 1 + ((a:0 ? a:1 : 5) / 100.0)
  let hsl = color#HexToHSL(a:color)
  let hsl[2] = hsl[2] * amount > 100.0 ? 100 : float2nr(round(hsl[2] * amount))
  let hex = color#HSLtoHex(hsl)
  return hex
endfu

" @params String                 color      The color
" @params {Number|String|Float} [amount=5]  The percentage of darkness
fu! color#Darken(color, ...)
  let amount = 1 - ((a:0 ? a:1 : 5) / 100.0)
  let hsl = color#HexToHSL(a:color)
  let hsl[2] = hsl[2] * amount < 0.0 ? 0 : float2nr(round(hsl[2] * amount))
  let hex = color#HSLtoHex(hsl)
  return hex
endfu

" }}}
