'use strict'


$ ->
  $overlay = $('#overlay')

  $overlay.on 'click', ->
    $overlay.css visibility: 'hidden'

  $('form').on 'submit', (e) ->
    e.preventDefault()

    $overlay
      .children().remove().end()
      .append $('<img />').attr src: "/api/placeholder?#{$(@).serialize()}"
      .css visibility: 'visible'
