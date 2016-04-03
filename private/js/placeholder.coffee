'use strict'


$form = $('form')
$hits = $('#hits')
$logo = $('select[name=logo]')
$overlay = $('#overlay')
$range = $('input[type=range]')


$.fn.placeImage = (src) ->
  return $(@)
    .append $('<img />').attr {src}
    .css visibility: 'visible'


$ ->
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
      .placeImage "/api/placeholder?#{params}"

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


  $('#logos').on 'click', (e) ->
    $overlay.placeImage $(@).attr('href')
    e.preventDefault()
    return


  $('#reset').on 'click', (e) ->
    $form.trigger 'reset'
    $range.trigger 'change'
    $logo.focus()
    e.preventDefault()
    return


  $('input.text').on 'focus', ->
    $(@).select()
    return


  $logo.focus()
  return
