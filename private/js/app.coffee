'use strict'


$ ->
  $form = $('form')
  $hits = $('#hits')
  $overlay = $('#overlay')
  $range = $('input[type=range]')


  $overlay.on 'click', ->
    $overlay
      .css visibility: 'hidden'
      .children().remove()

    return


  $form.on 'submit', (e) ->
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

    return


  $range.on 'change', ->
    $me = $(@)

    $me.prev('label').text("Quality (#{$me.val()}%)")
    return


  $('#reset').on 'click', (e) ->
    $form.trigger 'reset'
    $range.trigger 'change'
    $('input').first().focus()
    e.preventDefault()
    return


  $('input.text')
    .on 'focus', ->
      $(@).select()
      return
    .first().focus()


  return
