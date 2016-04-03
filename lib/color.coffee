'use strict'


chroma = require('chroma-js')


rgbToHex = (r, g, b) ->
  hex = (c) ->
    val = c.toString(16)
    return if (val.length is 1) then "0#{val}" else val

  return "##{ hex(r) }#{ hex(g) }#{ hex(b) }"


invert = (color) ->
  channels = chroma(color).rgb()
  channels[i] = (if i is 3 then 1 else 255) - c for c, i in channels

  return "rgb(#{ channels.join(',') })"


exports.invert = invert
