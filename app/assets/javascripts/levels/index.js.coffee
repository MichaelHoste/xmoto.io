bind_images = ->
  $('img').on('mouseenter', ->
    level_file  = $(this).next('canvas').data('current-level')
    level_id    = $(this).next('canvas').data('current-level-id')
    replay_file = $(this).next('canvas').data('replay-file')

    $.xmoto(level_file,
      canvas:      "#level_#{level_id}"
      loading:     "#loading_#{level_id}"
      chrono:      "#chrono_#{level_id}"
      replay_mode: true
      replay_file: replay_file
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


