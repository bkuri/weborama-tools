'use strict'


$overlay = $('#overlay')
$wizard = $('#wizard')
labels = finish: 'Download'
steps = 0
stepsOrientation = 'vertical'
transitionEffect = 'slideLeft'


build = ->
  text = @innerHTML.match(/\s(\w+)$/)[1]
  $wizard.find('ol').append $("<li>#{ text }: <span class='red'></span></li>")
  steps++
  return $(@)


input = (index=0) ->
  return $('input', "#wizard-p-#{ index }")


onFinished = ->
  $overlay.css visibility: 'visible'

  setTimeout ->
    window.location.href = '/'
    return
  , 3000

  return


onInit = ->
  $(window).keydown (event) ->
    prevent = yes

    switch event.which
      when 13
        index = $wizard.steps('getCurrentIndex')
        $wizard.steps if (index is steps) then 'finish' else 'next'

      when 33, 34
        $wizard.steps if (e.which is 33) then 'previous' else 'next'

      else
        prevent = no

    event.preventDefault() if prevent
    return

  $overlay.css visibility: 'hidden'
  input().focus()
  return


onStepChanging = (event, index) ->
  switch index
    when 0
      $input = input(index)
      valid = $input.val().match($input.attr 'pattern')

      setTimeout (-> $input.focus().select()), 100 unless valid
      $input.toggleClass 'error', (not valid)
      return valid

    when steps - 1
      for s in [1..steps]
        $("ol > li:nth-child(#{ s }) > span", $wizard).text ->
          $i = input(s - 1)

          return $i.val() if ($i.length is 1)
          text = []

          $i.each ->
            text.push @value
            return

          return text.join('x')

  return yes


onStepChanged = (event, index) ->
  input(index).focus().select()
  return


range = ->
  $me = $(@)
  $me.prev('label').text "#{ $me.attr 'name' }: #{ $me.val() }px"
  return


$ ->
  $wizard
    .steps {labels, onFinished, onInit, onStepChanged, onStepChanging, stepsOrientation, transitionEffect}
    .find('.steps li:not(:last) a').each(build).end()
    .find('input[type=range]').change(range).trigger('change').end()

  return
