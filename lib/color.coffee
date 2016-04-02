'use strict'


rgbToHex = (r, g, b) ->
  c2h = (c) ->
    hex = c.toString(16)
    return if (hex.length is 1) then "0#{hex}" else hex

  return "##{c2h(r)}#{c2h(g)}#{c2h(b)}"


invert = (rgb...) ->
    rgb = rgb.join(',').replace(/rgb\(|\)|rgba\(|\)|\s/gi, '').split(',')
    rgb[i] = (if i is 3 then 1 else 255) - c for c, i in rgb
    return rgbToHex(rgb[0], rgb[1], rgb[2])


exports.invert = invert
