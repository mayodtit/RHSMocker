# We're only supporting US phone numbers for now with no extensions.
# NOTE: Twilio supports dialing extensions (via sendDigits option).
module PhoneNumberUtil
  VALIDATION_REGEX = /\A\d{10}\Z/
end
