$ ->
  $(".talk").click ->
    NativeBridge.call('newConsult', {contentId: $(@).data("content-id"), message: $(@).data("message")})

  $(".consult-link").click ->
    if not $(@).data("consult-id")
      return
    NativeBridge.call('openConsult', {consultId: $(@).data("consult-id")})

  $(".content-link").click ->
    if not $(@).data("content-id")
      return
    NativeBridge.call('openContent', {contentId: $(@).data("content-id")})

  $(".card-link").click ->
    if not $(@).data("card-id")
      return
    NativeBridge.call('openCard', {cardId: $(@).data("card-id")})

  $(".gender").click ->
    NativeBridge.call('setGender', {gender: $(@).data("gender")})

  $(".allergies").click ->
    NativeBridge.call('openView', {view: "allergies"})

  $(".no-allergies").click ->
    NativeBridge.call('addAllergy', {allergyId: $(@).data("allergy-id")})

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
