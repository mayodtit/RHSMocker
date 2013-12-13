$ ->
  $(".talk").click ->
    NativeBridge.call('newConsult', {id: $(@).data("content-id"), message: $(@).data("message")})

  $(".new-consult").click ->
    NativeBridge.call('newConsult', {message: $(@).data("message"), consult_type: $(@).data("consult-type")})

  $(".consult-link").click ->
    if not $(@).data("consult-id")
      return
    NativeBridge.call('openConsult', {id: $(@).data("consult-id")})

  $(".content-link").click ->
    if not $(@).data("content-id")
      return
    NativeBridge.call('openContent', {id: $(@).data("content-id")})

  $(".card-link").click ->
    if not $(@).data("card-id")
      return
    NativeBridge.call('openCard', {id: $(@).data("card-id")})

  $(".gender").click ->
    NativeBridge.call('setGender', {gender: $(@).data("gender")})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})

  $(".allergies").click ->
    NativeBridge.call('openPage', {page: "allergies"})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})

  $(".no-allergies").click ->
    NativeBridge.call('addAllergy', {id: $(@).data("allergy-id")})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})

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
