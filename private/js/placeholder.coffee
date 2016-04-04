'use strict'


$form = $('form')
$logo = $('select[name=logo]')
$overlay = $('#overlay')
$range = $('input[type=range]')


$.fn.placeImage = (src) ->
  return $(@)
    .append $("<img src='#{ src }' />")
    .css visibility: 'visible'


$ ->
  $overlay.on 'click', ->
    $overlay
      .css visibility: 'hidden'
      .children().remove()

    return


  $form.on 'submit', (event) ->
    $hits = $('#hits')
    last = $overlay.data('params')
    params = $(@).serialize()

    $overlay
      .data {params}
      .placeImage "/api/placeholder?#{ params }"

    event.preventDefault()
    return if (params is last)

    hits = $hits.data('hits') + 1

    $hits
      .text hits
      .data {hits}

    return


  $range.on 'change', ->
    $me = $(@)
    $me.prev('label').text("Quality (#{ $me.val() }%)")
    return


  $('#logos').on 'click', (event) ->
    $overlay.placeImage $(@).attr('href')
    event.preventDefault()
    return


  $('#reset').on 'click', (event) ->
    $form.trigger 'reset'
    $range.trigger 'change'
    $logo.focus()
    event.preventDefault()
    return


  $('input.text').on 'focus', ->
    $(@).select()
    return


  $logo.focus()
  return
