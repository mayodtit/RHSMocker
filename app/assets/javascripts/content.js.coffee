$ ->
  $(".talk").click ->
    NativeBridge.call('newConsult', {id: $(@).data("content-id"), message: $(@).data("message")})
    # TODO - remove the following when the client is ready to stop support
    document.actionJSON = JSON.stringify([{type: "launch_call_screen", body: {content_id: $(@).data("content-id").toString(), message_body: $(@).data("message")}}])
    window.location.href = "http://dontload"

  $(".consult-link").click ->
    if not $(@).data("consult-id")
      return
    NativeBridge.call('openConsult', {id: $(@).data("consult-id")})
    # TODO - remove the following when the client is ready to stop support
    document.actionJSON = JSON.stringify([{type:"open_consult", body: {consult_id: $(@).data("consult-id").toString()}}])
    window.location.href = "http://dontload"

  $(".content-link").click ->
    if not $(@).data("content-id")
      return
    NativeBridge.call('openContent', {id: $(@).data("content-id")})
    # TODO - use the below until the client supports the "open_content" hook
    if window.mayo_terms_of_service_url?
      window.location.href = window.mayo_terms_of_service_url

  $(".card-link").click ->
    if not $(@).data("card-id")
      return
    NativeBridge.call('openCard', {id: $(@).data("card-id")})
    # TODO - remove the following when the client is ready to stop support
    document.actionJSON = JSON.stringify([{type: "fullscreen"}])
    window.location.href = "http://dontload"

  $(".gender").click ->
    NativeBridge.call('setGender', {gender: $(@).data("gender")})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})
    # TODO - remove the following when the client is ready to stop support
    document.actionJSON = JSON.stringify([{type:"set_gender", body: {gender: $(@).data("gender")}}, {type: "save_item"}])
    window.location.href = "http://dontload"

  $(".allergies").click ->
    NativeBridge.call('openPage', {page: "allergies"})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})
    # TODO - remove the following when the client is ready to stop support
    document.actionJSON = JSON.stringify([{type:"goto_allergies"}, {type: "save_item"}])
    window.location.href = "http://dontload"

  $(".no-allergies").click ->
    NativeBridge.call('addAllergy', {id: $(@).data("allergy-id")})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})
    # TODO - remove the following when the client is ready to stop support
    document.actionJSON = JSON.stringify([{type:"add_allergy", body:{allergy_id: $(@).data('allergy-id').toString()}}, {type: "save_item"}])
    window.location.href = "http://dontload"

  $(".diet-question .tile").click ->
    $('.' + $(@).data('type')).toggle()

  $(".date").each ->
    d = new Date(0)
    d.setUTCSeconds $(@).data("time")
    $(@).text((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear())

  $(".section-head").click ->
    $(@).toggleClass("closed")
    $("#section-" + $(@).data("section-id")).toggleClass("disabled")

  # TODO - the following is an example of how to use the NativeBridge
  $(".nb-submit").click (event) ->
    event.preventDefault()
    NativeBridge.call('dansCard', {value: $("#number").val()}, NativeBridgeCallback.callback)

class NativeBridgeCallback
  @callback: () ->
    alert 'callback'
