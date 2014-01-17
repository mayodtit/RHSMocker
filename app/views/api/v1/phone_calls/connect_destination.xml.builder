xml.instruct!
xml.Response do
  xml.Dial do
    xml.Conference @phone_call.identifier_token, beep: false, endConferenceOnExit: false, startConferenceOnEnter: true
  end
end