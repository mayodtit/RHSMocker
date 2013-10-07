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

  $(".diet-question .tile").click ->
    $('.' + $(@).data('type')).toggle()

  $(".gender").click ->
    document.actionJSON = JSON.stringify([{type:"set_gender", body: {gender: $(@).data("gender")}}, {type: "save_item"}])
    window.location.href = "http://dontload"

  $(".date").each ->
    d = new Date(0)
    d.setUTCSeconds $(@).data("time")
    $(@).text((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear())
