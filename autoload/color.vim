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
let s:patterns = {
      \ 'hex' : '\v#?(\x{2})(\x{2})(\x{2})',
      \ 'rgb' : '\vrgb\s*\((\d+)\s*,(\d+)\s*,(\d+)\s*)\s*',
      \ 'rgba': '\vrgba\s*\((\d+)\s*,(\d+)\s*,(\d+)\s*,(\d+)\s*)\s*',
      \ }

" Functions: {{{1

" @params  String       string   The string to test
" @returns Boolean     [0 or 1]  if string matches: rrggbb OR #rrggbb OR #rgb
fu! color#Test(string)
  for key in keys(s:patterns)
    if a:string =~# s:patterns[key]
      return 1
    end
  endfor
  return 0
endfu

" @params (r, g, b|[r, g, b])
" @returns String       A RGB color
fu! color#RGBtoHex(...)
  let [r, g, b] = (a:0 == 1 ? a:1 : a:000)
  return printf('#%02x%02x%02x', r, g, b)
endfu

" @param {String|Number} color
fu! color#HexToRGB(color)
  let color = (type(a:color) == v:t_number ? printf('%x', a:color) : a:color)
  let matches = matchlist(color, s:patterns['hex'])
  if len(matches) < 4
    echohl Error | echom 'Could not parse ' . string(color) | echohl None
    return
  endif
  return map(matches[1: 3], 'str2nr(v:val, 16)')
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
  let [h, s, l] = (a:0 == 1 ? a:1 : a:000)

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
  let [r, g, b] = (a:0 == 1 ? a:1 : a:000)

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
fu! color#HexToHSL(color)
  let [r, g, b] = color#HexToRGB(a:color)
  return color#RGBtoHSL(r, g, b)
endfu

fu! color#HSLtoHex(...)
  let [h, s, l] = (a:0 == 1 ? a:1 : a:000)
  let [r, g, b] = color#HSLtoRGB(h, s, l)
  return color#RGBtoHex(r, g, b)
endfu

" @params String                 color      The color
" @params {Number|String|Float} [amount=5]  The percentage of light
fu! color#Lighten(color, ...)
  let amount = 1 + ((a:0 ? a:1 : 5) / 100.0)
  let hsl = color#HexToHSL(a:color)
  let hsl[2] = hsl[2] * amount > 100.0 ? 100 : float2nr(round(hsl[2] * amount))
  return color#HSLtoHex(hsl)
endfu

" @params String                 color      The color
" @params {Number|String|Float} [amount=5]  The percentage of darkness
fu! color#Darken(color, ...)
  let amount = 1 - ((a:0 ? a:1 : 5) / 100.0)
  let hsl = color#HexToHSL(a:color)
  let hsl[2] = hsl[2] * amount < 0.0 ? 0 : float2nr(round(hsl[2] * amount))
  return color#HSLtoHex(hsl)
endfu

" Find the closest xterm-256 approximation to the given RGB value
" @params (r, g, b|[r, g, b])
" @returns Number       Between 0 and 255, compatible with xterm.
fu! color#RGBtoShort(...)
  let [r, g, b] = ( a:0 == 1 ? a:1 : a:000 )
  let incs = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]
  let closest = []
  for part in [r, g, b]
    let i = 0
    while (i < len(incs) - 1)
      let [lower, upper] = [incs[i], incs[i + 1]]
      if part >= lower && part <= upper
        let lowerdiff = abs(lower - part)
        let upperdiff = abs(upper - part)
        let closest += [lowerdiff < upperdiff ? lower : upper]
        break
      endif
      let i += 1
    endwhile
  endfor
  let hex = call('printf', ['#%02x%02x%02x'] + closest)
  return s:hex_to_short[hex]
endfu

" @params  String       color      The color
" @returns Number       Between 0 and 255, compatible with xterm.
fu! color#HexToShort(color)
  return color#RGBtoShort(color#HexToRGB(a:color))
endfu

" Color look-up table
let s:short_to_hex = {
      \ 0: '#000000',
      \ 1: '#800000',
      \ 2: '#008000',
      \ 3: '#808000',
      \ 4: '#000080',
      \ 5: '#800080',
      \ 6: '#008080',
      \ 7: '#c0c0c0',
      \ 8: '#808080',
      \ 9: '#ff0000',
      \ 10: '#00ff00',
      \ 11: '#ffff00',
      \ 12: '#0000ff',
      \ 13: '#ff00ff',
      \ 14: '#00ffff',
      \ 15: '#ffffff',
      \ 16: '#000000',
      \ 17: '#00005f',
      \ 18: '#000087',
      \ 19: '#0000af',
      \ 20: '#0000d7',
      \ 21: '#0000ff',
      \ 22: '#005f00',
      \ 23: '#005f5f',
      \ 24: '#005f87',
      \ 25: '#005faf',
      \ 26: '#005fd7',
      \ 27: '#005fff',
      \ 28: '#008700',
      \ 29: '#00875f',
      \ 30: '#008787',
      \ 31: '#0087af',
      \ 32: '#0087d7',
      \ 33: '#0087ff',
      \ 34: '#00af00',
      \ 35: '#00af5f',
      \ 36: '#00af87',
      \ 37: '#00afaf',
      \ 38: '#00afd7',
      \ 39: '#00afff',
      \ 40: '#00d700',
      \ 41: '#00d75f',
      \ 42: '#00d787',
      \ 43: '#00d7af',
      \ 44: '#00d7d7',
      \ 45: '#00d7ff',
      \ 46: '#00ff00',
      \ 47: '#00ff5f',
      \ 48: '#00ff87',
      \ 49: '#00ffaf',
      \ 50: '#00ffd7',
      \ 51: '#00ffff',
      \ 52: '#5f0000',
      \ 53: '#5f005f',
      \ 54: '#5f0087',
      \ 55: '#5f00af',
      \ 56: '#5f00d7',
      \ 57: '#5f00ff',
      \ 58: '#5f5f00',
      \ 59: '#5f5f5f',
      \ 60: '#5f5f87',
      \ 61: '#5f5faf',
      \ 62: '#5f5fd7',
      \ 63: '#5f5fff',
      \ 64: '#5f8700',
      \ 65: '#5f875f',
      \ 66: '#5f8787',
      \ 67: '#5f87af',
      \ 68: '#5f87d7',
      \ 69: '#5f87ff',
      \ 70: '#5faf00',
      \ 71: '#5faf5f',
      \ 72: '#5faf87',
      \ 73: '#5fafaf',
      \ 74: '#5fafd7',
      \ 75: '#5fafff',
      \ 76: '#5fd700',
      \ 77: '#5fd75f',
      \ 78: '#5fd787',
      \ 79: '#5fd7af',
      \ 80: '#5fd7d7',
      \ 81: '#5fd7ff',
      \ 82: '#5fff00',
      \ 83: '#5fff5f',
      \ 84: '#5fff87',
      \ 85: '#5fffaf',
      \ 86: '#5fffd7',
      \ 87: '#5fffff',
      \ 88: '#870000',
      \ 89: '#87005f',
      \ 90: '#870087',
      \ 91: '#8700af',
      \ 92: '#8700d7',
      \ 93: '#8700ff',
      \ 94: '#875f00',
      \ 95: '#875f5f',
      \ 96: '#875f87',
      \ 97: '#875faf',
      \ 98: '#875fd7',
      \ 99: '#875fff',
      \ 100: '#878700',
      \ 101: '#87875f',
      \ 102: '#878787',
      \ 103: '#8787af',
      \ 104: '#8787d7',
      \ 105: '#8787ff',
      \ 106: '#87af00',
      \ 107: '#87af5f',
      \ 108: '#87af87',
      \ 109: '#87afaf',
      \ 110: '#87afd7',
      \ 111: '#87afff',
      \ 112: '#87d700',
      \ 113: '#87d75f',
      \ 114: '#87d787',
      \ 115: '#87d7af',
      \ 116: '#87d7d7',
      \ 117: '#87d7ff',
      \ 118: '#87ff00',
      \ 119: '#87ff5f',
      \ 120: '#87ff87',
      \ 121: '#87ffaf',
      \ 122: '#87ffd7',
      \ 123: '#87ffff',
      \ 124: '#af0000',
      \ 125: '#af005f',
      \ 126: '#af0087',
      \ 127: '#af00af',
      \ 128: '#af00d7',
      \ 129: '#af00ff',
      \ 130: '#af5f00',
      \ 131: '#af5f5f',
      \ 132: '#af5f87',
      \ 133: '#af5faf',
      \ 134: '#af5fd7',
      \ 135: '#af5fff',
      \ 136: '#af8700',
      \ 137: '#af875f',
      \ 138: '#af8787',
      \ 139: '#af87af',
      \ 140: '#af87d7',
      \ 141: '#af87ff',
      \ 142: '#afaf00',
      \ 143: '#afaf5f',
      \ 144: '#afaf87',
      \ 145: '#afafaf',
      \ 146: '#afafd7',
      \ 147: '#afafff',
      \ 148: '#afd700',
      \ 149: '#afd75f',
      \ 150: '#afd787',
      \ 151: '#afd7af',
      \ 152: '#afd7d7',
      \ 153: '#afd7ff',
      \ 154: '#afff00',
      \ 155: '#afff5f',
      \ 156: '#afff87',
      \ 157: '#afffaf',
      \ 158: '#afffd7',
      \ 159: '#afffff',
      \ 160: '#d70000',
      \ 161: '#d7005f',
      \ 162: '#d70087',
      \ 163: '#d700af',
      \ 164: '#d700d7',
      \ 165: '#d700ff',
      \ 166: '#d75f00',
      \ 167: '#d75f5f',
      \ 168: '#d75f87',
      \ 169: '#d75faf',
      \ 170: '#d75fd7',
      \ 171: '#d75fff',
      \ 172: '#d78700',
      \ 173: '#d7875f',
      \ 174: '#d78787',
      \ 175: '#d787af',
      \ 176: '#d787d7',
      \ 177: '#d787ff',
      \ 178: '#d7af00',
      \ 179: '#d7af5f',
      \ 180: '#d7af87',
      \ 181: '#d7afaf',
      \ 182: '#d7afd7',
      \ 183: '#d7afff',
      \ 184: '#d7d700',
      \ 185: '#d7d75f',
      \ 186: '#d7d787',
      \ 187: '#d7d7af',
      \ 188: '#d7d7d7',
      \ 189: '#d7d7ff',
      \ 190: '#d7ff00',
      \ 191: '#d7ff5f',
      \ 192: '#d7ff87',
      \ 193: '#d7ffaf',
      \ 194: '#d7ffd7',
      \ 195: '#d7ffff',
      \ 196: '#ff0000',
      \ 197: '#ff005f',
      \ 198: '#ff0087',
      \ 199: '#ff00af',
      \ 200: '#ff00d7',
      \ 201: '#ff00ff',
      \ 202: '#ff5f00',
      \ 203: '#ff5f5f',
      \ 204: '#ff5f87',
      \ 205: '#ff5faf',
      \ 206: '#ff5fd7',
      \ 207: '#ff5fff',
      \ 208: '#ff8700',
      \ 209: '#ff875f',
      \ 210: '#ff8787',
      \ 211: '#ff87af',
      \ 212: '#ff87d7',
      \ 213: '#ff87ff',
      \ 214: '#ffaf00',
      \ 215: '#ffaf5f',
      \ 216: '#ffaf87',
      \ 217: '#ffafaf',
      \ 218: '#ffafd7',
      \ 219: '#ffafff',
      \ 220: '#ffd700',
      \ 221: '#ffd75f',
      \ 222: '#ffd787',
      \ 223: '#ffd7af',
      \ 224: '#ffd7d7',
      \ 225: '#ffd7ff',
      \ 226: '#ffff00',
      \ 227: '#ffff5f',
      \ 228: '#ffff87',
      \ 229: '#ffffaf',
      \ 230: '#ffffd7',
      \ 231: '#ffffff',
      \ 232: '#080808',
      \ 233: '#121212',
      \ 234: '#1c1c1c',
      \ 235: '#262626',
      \ 236: '#303030',
      \ 237: '#3a3a3a',
      \ 238: '#444444',
      \ 239: '#4e4e4e',
      \ 240: '#585858',
      \ 241: '#626262',
      \ 242: '#6c6c6c',
      \ 243: '#767676',
      \ 244: '#808080',
      \ 245: '#8a8a8a',
      \ 246: '#949494',
      \ 247: '#9e9e9e',
      \ 248: '#a8a8a8',
      \ 249: '#b2b2b2',
      \ 250: '#bcbcbc',
      \ 251: '#c6c6c6',
      \ 252: '#d0d0d0',
      \ 253: '#dadada',
      \ 254: '#e4e4e4',
      \ 255: '#eeeeee',
      \ }

let s:hex_to_short = {}
for short in keys(s:short_to_hex)
  let s:hex_to_short[s:short_to_hex[short]] = short
endfor

" }}}
