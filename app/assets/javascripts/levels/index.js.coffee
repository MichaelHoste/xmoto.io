bind_images = ->
  $('img').on('mouseenter', ->
    level_id       = $(this).next('canvas').data('level-id')
    level_filename = $(this).next('canvas').data('level-filename')
    replay         = $(this).next('canvas').data('replay')

    $.xmoto(level_filename,
      canvas:      "#level_#{level_id}"
      loading:     "#loading_#{level_id}"
      chrono:      "#chrono_#{level_id}"
      playable:    false
      replays:     [{ replay: replay, follow: true }]
      zoom:        25.0
    )

    $(this).hide()
    $("#level_#{level_id}").show()
    bind_canvas()
  )

bind_canvas = ->
  $('canvas').on('mouseleave', ->
    $(this).hide()
    $(this).prev('img').show()
  )

$ ->
  if $('#levels-index').length
    $('canvas').hide()
    bind_images()


