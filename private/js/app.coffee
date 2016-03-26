'use strict'


$ ->
  $hits = $('#hits')
  $overlay = $('#overlay')

  $overlay.on 'click', ->
    $overlay.css visibility: 'hidden'

  $('form').on 'submit', (e) ->
    last = $overlay.data('params')
    params = $(@).serialize()

    $overlay
      .children().remove().end()
      .data {params}
      .append $('<img />').attr src: "/api/placeholder?#{params}"
      .css visibility: 'visible'

    e.preventDefault()
    return if (params is last)

    hits = $hits.data('hits') + 1

    $hits
      .text hits
      .data {hits}
