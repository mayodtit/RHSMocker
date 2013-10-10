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

  $(".allergies").click ->
    document.actionJSON = JSON.stringify([{type:"goto_allergies"}, {type: "save_item"}])
    window.location.href = "http://dontload"

  $(".no-allergies").click ->
    document.actionJSON = JSON.stringify([{type:"add_allergy", body:{allergy_id: $(@).data('allergy-id').toString()}}, {type: "save_item"}])
    window.location.href = "http://dontload"

  $(".date").each ->
    d = new Date(0)
    d.setUTCSeconds $(@).data("time")
    $(@).text((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear())

  # TODO - this is much cleaner to just do in CSS, need to clean up importer first
  $(".section_head_show:last").css({'border-bottom': '1px solid #CCCCCC'})
  $(".section:last").css({'border-bottom': '1px solid #CCCCCC'})
  $(".section_head_show:last").toggle (->
    $(@).css({'border-bottom': 'none'})
    $(".section:last").show()
  ), ->
    $(@).css({'border-bottom': '1px solid #CCCCCC'})
    $(".section:last").hide()

  # TODO - the following is an example of how to use the NativeBridge
  $(".nb-submit").click (event) ->
    event.preventDefault()
    NativeBridge.call('dansCard', {value: $("#number").val()}, NativeBridgeCallback.callback)

class NativeBridgeCallback
  @callback: () ->
    alert 'callback'
