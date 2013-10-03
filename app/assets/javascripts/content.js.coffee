$ ->
  $(".talk").click ->
    document.actionJSON = JSON.stringify([{type: "launch_call_screen", body: {content_id: $(@).data("content-id").toString(), message_body: $(@).data("message")}}])
    window.location.href = "http://dontload"

  $(".fullscreen-available").click ->
    document.actionJSON = JSON.stringify([{type: "fullscreen"}])
    window.location.href = "http://dontload"

  $(".consult-link").click ->
    document.actionJSON = JSON.stringify([{type:"open_consult", body: {consult_id: $(@).data("consult-id").toString()}}])
    window.location.href = "http://dontload"
