xml.instruct!
xml.Response do
  xml.Say "Hi #{@phone_call.dialer.first_name}, I'm connecting you with #{@phone_call.user.first_name}.", voice: 'woman'
  xml.Dial do
    xml.Conference @phone_call.identifier_token, beep: false, endConferenceOnExit: false, startConferenceOnEnter: true
  end
end