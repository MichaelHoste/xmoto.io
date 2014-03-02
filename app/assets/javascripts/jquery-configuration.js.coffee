$(document).bind("ajaxSend", (elm, xhr, s) ->
  if s.type == "POST"
    csrf_token = $('meta[name="csrf-token"]').attr('content')
    xhr.setRequestHeader('X-CSRF-Token', csrf_token)
)
