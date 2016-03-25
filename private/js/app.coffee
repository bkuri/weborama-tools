'use strict'


$ ->
  $overlay = $('#overlay')

  $overlay.on 'click', ->
    $overlay.css visibility: 'hidden'

  $('form').on 'submit', (e) ->
    src = $(@).serialize()
    url = '/api/placeholder'

    e.preventDefault()

    $.get url, src, (res) ->
      $overlay
        .children().remove().end()
        .append $('<img />').attr src: "#{url}?#{src}"
        .css visibility: 'visible'
