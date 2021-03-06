$ ->
  $(".talk").click ->
    NativeBridge.call('newConsult', {id: $(@).data("content-id"), message: $(@).data("message")})

  $(".new-consult").click ->
    NativeBridge.call('newConsult', {card_id: $(".card").data("id"), title: $(@).data("title"), message: $(@).data("message"), consult_type: [$(@).data("consult-type")]})

  $(".open-consult").click ->
    NativeBridge.call('openConsult')

  $(".open-consult-with-message").click ->
    NativeBridge.call('openConsult', {message: $(@).data("message")})

  $(".schedule-call").click ->
    NativeBridge.call('scheduleCall')

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
    NativeBridge.call('saveCard', {id: $(".card").data("id")})

  $(".update-association").click ->
    userId = $(@).data("user-id")
    cardId = $(".card").data("id")
    callback = () ->
      NativeBridgeCallback.showProfileAndDismiss(userId, cardId)
    if ($(@).data("state-event") == "enable") && userId
      NativeBridge.call("updateAssociation", {id: $(@).data("association-id"), state_event: $(@).data("state-event")}, callback)
    else
      NativeBridge.call("updateAssociation", {id: $(@).data("association-id"), state_event: $(@).data("state-event")})
      NativeBridge.call('dismissCard', {id: $(".card").data("id")})

  $(".update-inverse-association").click ->
    userId = $(@).data("user-id")
    cardId = $(".card").data("id")
    callback = () ->
      NativeBridgeCallback.showProfileAndDismiss(userId, cardId)
    if ($(@).data("state-event") == "enable") && $(@).data("user-id")
      NativeBridge.call("updateInverseAssociation", {id: $(@).data("association-id"), state_event: $(@).data("state-event")}, callback)
    else
      NativeBridge.call("updateInverseAssociation", {id: $(@).data("association-id"), state_event: $(@).data("state-event")})
      NativeBridge.call('dismissCard', {id: $(".card").data("id")})

  $(".click-save").click ->
    NativeBridge.call('saveCard', {id: $(".card").data("id")})

  $(".click-dismiss").click ->
    NativeBridge.call('dismissCard', {id: $(".card").data("id")})

  $(".allergies").click ->
    NativeBridge.call('openPage', {page: "allergies"})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})

  $(".no-allergies").click ->
    NativeBridge.call('addAllergy', {id: $(@).data("allergy-id")})
    NativeBridge.call('saveCard', {id: $(@).data("card-id")})

  $(".birthday").click ->
    NativeBridge.call('editProfile', {allowed_fields: ['birthdate'], card_id: $(@).data("card-id"), id: $(@).data("user-id")})

  $(".tell-a-friend").click ->
    NativeBridge.call('tellAFriend')

  $(".diet-question .tile").click ->
    $('.' + $(@).data('type')).toggle()

  $(".date").each ->
    d = new Date(0)
    d.setUTCSeconds $(@).data("time")
    $(@).text((d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear())

  months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  $(".time").each ->
    d = new Date(0)
    d.setUTCSeconds $(@).data("time")
    $(@).text(months[d.getMonth()] + " " + d.getDate() + ", " + d.toLocaleTimeString().replace(/:\d+ /, ' '))

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
  @showProfileAndDismiss: (userId, cardId) ->
    NativeBridge.call("showProfile", {id: userId})
    NativeBridge.call("dismissCard", {id: cardId})

$(window).load ->
  NativeBridge.call('windowLoaded', {id: $(".card").data("id")})
