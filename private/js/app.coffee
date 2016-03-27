'use strict'


$ ->
  $hits = $('#hits')
  $overlay = $('#overlay')

  $overlay.on 'click', ->
    $overlay
      .css visibility: 'hidden'
      .children().remove().end()

  $('form').on 'submit', (e) ->
    last = $overlay.data('params')
    params = $(@).serialize()

    $overlay
      .data {params}
      .append $('<img />').attr src: "/api/placeholder?#{params}"
      .css visibility: 'visible'

    e.preventDefault()
    return if (params is last)

    hits = $hits.data('hits') + 1

    $hits
      .text hits
      .data {hits}

  $('input[type=text], input[type=number]').on 'focus', ->
    $(@).select()

  $('input[type=range]').on 'change', (e) ->
    $me = $(@)
    $me.prev('label').text("Quality (#{$me.val()}%)")
