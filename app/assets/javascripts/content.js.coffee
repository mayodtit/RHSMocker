$ ->
  $(".talk").click ->
    document.actionJSON = JSON.stringify([{type: "launch_call_screen", body: {content_id: $(@).data("content-id").toString(), message_body: $(@).data("message")}}])
    window.location.href = "http://dontload"
