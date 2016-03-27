'use strict'


$ ->
  $hits = $('#hits')
  $overlay = $('#overlay')

  $overlay.on 'click', ->
    $overlay
      .css visibility: 'hidden'
      .children().remove()

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

  $('input.text')
    .on 'focus', -> $(@).select()
    .first().focus()

  $('input[type=range]').on 'change', (e) ->
    $me = $(@)
    $me.prev('label').text("Quality (#{$me.val()}%)")
