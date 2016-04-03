'use strict'


$overlay = $('#overlay')
$wizard = $('#wizard')
labels = finish: 'Download'
steps = 0
transitionEffect = 'slideLeft'


build = ->
  text = @innerHTML.match(/\s(\w+)$/)[1]
  $wizard.find('ol').append $("<li>#{ text }: <span class='red'></span></li>")
  steps++
  return $(@)


input = (index=0) ->
  return $('input', "#wizard-p-#{ index }")


onFinished = (event, index) ->
  $overlay.css visibility: 'visible'
  return


onInit = (event, index) ->
  $formats = $('#formats')

  $formats.append $("<option value='#{ f }'>#{ f }</option>") for f in ['2Ad', '3Ad', 'Angel ad', 'APTO', 'Banderole', 'Banner', 'Banner + Layer', 'Billboard', 'Billboard slider', 'Billboard XL', 'Black-Out', 'Careta', 'CornerAd', 'Cross device', 'Cross device billboard', 'Cube', 'Divide Ad', 'Double Sidekick', 'Double Slider', 'Emag', 'Expandable', 'Expandable leaderbord', 'Expandable rectangle', 'Extreme header', 'Fatboy + video', 'Filmstrip', 'Fixed position', 'Fixed scroll banner', 'Flip', 'FloorAd', 'FrameAd', 'FrontKick', 'FullScreen', 'Fullscreen attention layer', 'Fullscreen FloorAd', 'Gecko', 'Group Take Over', 'Halfpage', 'Halfpage + video', 'Header', 'HPTO', 'HPTO layer', 'IN CONTENT', 'in-app header', 'Inarticle', 'Insite', 'Intent message', 'Intent takeover (ITO)', 'Interactive preroll', 'Interscroller', 'Interstitial', 'inview', 'iTV leaderboard', 'Layer', 'Leaderboard', 'Lightbox', 'MastHead', 'Mobile banner', 'Mobile banner + fullscreen layer', 'Mobile double banner', 'Mobile halfpage', 'Mobile halfpage + fullscreen layer', 'Mobile slider', 'MPU', 'MSN custom header', 'Portrait', 'Post Click', 'Preroll', 'Pushdown', 'Rectangle', 'Rectangle to fullscreen', 'Responsive homepage ad', 'Responsive HPTO', 'Roadblock', 'Rubrieks Takeover', 'Screenad', 'Sidebox', 'Sidekick', 'Skin', 'Skybox', 'Skyscraper', 'Slider', 'Slides', 'Slingshot', 'Splashpage', 'SuperExpanding', 'SuperLayer', 'Tablet halfpage', 'Takeover', 'U WallPaper', 'Video banner', 'Video rectangle', 'Video2Halfpage', 'VideoSkin', 'Videostrip', 'VPAID', 'VPAID Ad Bar', 'Vpaid Expand Ad', 'Vpaid Filmstrip', 'Vpaid Freestyle', 'Vpaid Share View', 'WallPaper', 'Windows live', 'WoW preroll', 'Wow Videobox']

  $(window).keydown (e) ->
    prevent = yes

    switch e.which
      when 13
        index = $wizard.steps('getCurrentIndex')
        $wizard.steps if (index is steps) then 'finish' else 'next'

      when 33, 34
        $wizard.steps if (e.which is 33) then 'previous' else 'next'

      else
        prevent = no

    e.preventDefault() if prevent
    return

  $overlay.css visibility: 'hidden'
  input().focus()
  return


onStepChanging = (event, index, newIndex) ->
  switch index
    when 0
      $input = input(index)
      valid = String($input.val()).match($input.attr 'pattern')

      setTimeout ->
        $input.focus().select()
      , 100 unless valid

      $input.toggleClass 'error', (not valid)
      return valid

    when steps - 1
      for s in [1..steps]
        $("ol > li:nth-child(#{s}) span", $wizard).text ->
          $i = input(s - 1)

          return $i.val() if ($i.length is 1)
          text = []

          $i.each ->
            text.push @value
            return

          return text.join('x')

  return yes


onStepChanged = (event, index, lastIndex) ->
  input(index).focus().select()
  return


range = ->
  $me = $(@)
  $me.prev('label').text "#{ $me.attr 'name' }: #{ $me.val() }px"
  return


$ ->
  $wizard
    .steps {labels, onInit, onFinished, onStepChanged, onStepChanging, transitionEffect}
    .find('.steps li:not(:last) a').each(build).end()
    .find('input[type=range]').change(range).trigger('change').end()

  return
