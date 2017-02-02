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
" }}}

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

" @param String         color
fu! color#HexToRGB(color)
  let matches = matchlist(a:color, s:patterns['hex'])
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
" @param   Number  h    OR     @param  Array [h, s, l]
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
" @param   Number  r    OR     @param  Array [r, g, b]
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
" @params  String       color      The color
" @returns Number       Between 0 and 255, compatible with xterm.
fu! color#HexToShort(color)
  if has_key(s:hex_to_short, a:color)
    return s:hex_to_short[a:color]
  endif
  let [r, g, b] = color#HexToRGB(a:color)
  let best_key = ''
  let best_dst = -1
  for key in keys(s:hex_to_short)
    let [kr, kg, kb] = color#HexToRGB(key)
    let dr = r - kr | let dg = g - kg | let db = b - kb
    let dist = dr * dr + dg * dg + db * db
    if best_dst == -1 || dist < best_dst
      let best_dst = dist
      let best_key = key
    endif
  endfor
  let short = s:hex_to_short[best_key]
  let s:hex_to_short[a:color] = short
  return short
endfu

" Find the closest xterm-256 approximation to the given RGB value
" @params (r, g, b|[r, g, b])
" @returns Number       Between 0 and 255, compatible with xterm.
fu! color#RGBtoShort(...)
  let [r, g, b] = (a:0 == 1 ? a:1 : a:000)
  return color#HexToShort(color#RGBtoHex(r, g, b))
endfu

" Color look-up table
let s:hex_to_short = {
      \ '#000000':  '16', '#00005f':  '17', '#000087':  '18', '#0000af':  '19', '#0000d7':  '20',
      \ '#0000ff':  '21', '#005f00':  '22', '#005f5f':  '23', '#005f87':  '24', '#005faf':  '25',
      \ '#005fd7':  '26', '#005fff':  '27', '#008700':  '28', '#00875f':  '29', '#008787':  '30',
      \ '#0087af':  '31', '#0087d7':  '32', '#0087ff':  '33', '#00af00':  '34', '#00af5f':  '35',
      \ '#00af87':  '36', '#00afaf':  '37', '#00afd7':  '38', '#00afff':  '39', '#00d700':  '40',
      \ '#00d75f':  '41', '#00d787':  '42', '#00d7af':  '43', '#00d7d7':  '44', '#00d7ff':  '45',
      \ '#00ff00':  '46', '#00ff5f':  '47', '#00ff87':  '48', '#00ffaf':  '49', '#00ffd7':  '50',
      \ '#00ffff':  '51', '#5f0000':  '52', '#5f005f':  '53', '#5f0087':  '54', '#5f00af':  '55',
      \ '#5f00d7':  '56', '#5f00ff':  '57', '#5f5f00':  '58', '#5f5f5f':  '59', '#5f5f87':  '60',
      \ '#5f5faf':  '61', '#5f5fd7':  '62', '#5f5fff':  '63', '#5f8700':  '64', '#5f875f':  '65',
      \ '#5f8787':  '66', '#5f87af':  '67', '#5f87d7':  '68', '#5f87ff':  '69', '#5faf00':  '70',
      \ '#5faf5f':  '71', '#5faf87':  '72', '#5fafaf':  '73', '#5fafd7':  '74', '#5fafff':  '75',
      \ '#5fd700':  '76', '#5fd75f':  '77', '#5fd787':  '78', '#5fd7af':  '79', '#5fd7d7':  '80',
      \ '#5fd7ff':  '81', '#5fff00':  '82', '#5fff5f':  '83', '#5fff87':  '84', '#5fffaf':  '85',
      \ '#5fffd7':  '86', '#5fffff':  '87', '#870000':  '88', '#87005f':  '89', '#870087':  '90',
      \ '#8700af':  '91', '#8700d7':  '92', '#8700ff':  '93', '#875f00':  '94', '#875f5f':  '95',
      \ '#875f87':  '96', '#875faf':  '97', '#875fd7':  '98', '#875fff':  '99', '#878700': '100',
      \ '#87875f': '101', '#878787': '102', '#8787af': '103', '#8787d7': '104', '#8787ff': '105',
      \ '#87af00': '106', '#87af5f': '107', '#87af87': '108', '#87afaf': '109', '#87afd7': '110',
      \ '#87afff': '111', '#87d700': '112', '#87d75f': '113', '#87d787': '114', '#87d7af': '115',
      \ '#87d7d7': '116', '#87d7ff': '117', '#87ff00': '118', '#87ff5f': '119', '#87ff87': '120',
      \ '#87ffaf': '121', '#87ffd7': '122', '#87ffff': '123', '#af0000': '124', '#af005f': '125',
      \ '#af0087': '126', '#af00af': '127', '#af00d7': '128', '#af00ff': '129', '#af5f00': '130',
      \ '#af5f5f': '131', '#af5f87': '132', '#af5faf': '133', '#af5fd7': '134', '#af5fff': '135',
      \ '#af8700': '136', '#af875f': '137', '#af8787': '138', '#af87af': '139', '#af87d7': '140',
      \ '#af87ff': '141', '#afaf00': '142', '#afaf5f': '143', '#afaf87': '144', '#afafaf': '145',
      \ '#afafd7': '146', '#afafff': '147', '#afd700': '148', '#afd75f': '149', '#afd787': '150',
      \ '#afd7af': '151', '#afd7d7': '152', '#afd7ff': '153', '#afff00': '154', '#afff5f': '155',
      \ '#afff87': '156', '#afffaf': '157', '#afffd7': '158', '#afffff': '159', '#d70000': '160',
      \ '#d7005f': '161', '#d70087': '162', '#d700af': '163', '#d700d7': '164', '#d700ff': '165',
      \ '#d75f00': '166', '#d75f5f': '167', '#d75f87': '168', '#d75faf': '169', '#d75fd7': '170',
      \ '#d75fff': '171', '#d78700': '172', '#d7875f': '173', '#d78787': '174', '#d787af': '175',
      \ '#d787d7': '176', '#d787ff': '177', '#d7af00': '178', '#d7af5f': '179', '#d7af87': '180',
      \ '#d7afaf': '181', '#d7afd7': '182', '#d7afff': '183', '#d7d700': '184', '#d7d75f': '185',
      \ '#d7d787': '186', '#d7d7af': '187', '#d7d7d7': '188', '#d7d7ff': '189', '#d7ff00': '190',
      \ '#d7ff5f': '191', '#d7ff87': '192', '#d7ffaf': '193', '#d7ffd7': '194', '#d7ffff': '195',
      \ '#ff0000': '196', '#ff005f': '197', '#ff0087': '198', '#ff00af': '199', '#ff00d7': '200',
      \ '#ff00ff': '201', '#ff5f00': '202', '#ff5f5f': '203', '#ff5f87': '204', '#ff5faf': '205',
      \ '#ff5fd7': '206', '#ff5fff': '207', '#ff8700': '208', '#ff875f': '209', '#ff8787': '210',
      \ '#ff87af': '211', '#ff87d7': '212', '#ff87ff': '213', '#ffaf00': '214', '#ffaf5f': '215',
      \ '#ffaf87': '216', '#ffafaf': '217', '#ffafd7': '218', '#ffafff': '219', '#ffd700': '220',
      \ '#ffd75f': '221', '#ffd787': '222', '#ffd7af': '223', '#ffd7d7': '224', '#ffd7ff': '225',
      \ '#ffff00': '226', '#ffff5f': '227', '#ffff87': '228', '#ffffaf': '229', '#ffffd7': '230',
      \ '#ffffff': '231', '#080808': '232', '#121212': '233', '#1c1c1c': '234', '#262626': '235',
      \ '#303030': '236', '#3a3a3a': '237', '#444444': '238', '#4e4e4e': '239', '#585858': '240',
      \ '#626262': '241', '#6c6c6c': '242', '#767676': '243', '#808080': '244', '#8a8a8a': '245',
      \ '#949494': '246', '#9e9e9e': '247', '#a8a8a8': '248', '#b2b2b2': '249', '#bcbcbc': '250',
      \ '#c6c6c6': '251', '#d0d0d0': '252', '#dadada': '253', '#e4e4e4': '254', '#eeeeee': '255',
      \ }
" }}}
