# We're only supporting US phone numbers for now with no extensions.
# NOTE: Twilio supports dialing extensions (via sendDigits option).
module PhoneNumberUtil
  VALIDATION_REGEX = /\A\d{10}\Z/

  def self.prep_phone_number_for_db(phone_number)
    return nil if phone_number.nil?

    phone_number = phone_number.to_s
    phone_number = phone_number.gsub /[^\d]/, ''
    phone_number
  end

  def self.format_for_dialing(phone_number)
    return nil if phone_number.nil?

    dialable_phone_number = phone_number

    if dialable_phone_number[0] != '+'
      if dialable_phone_number[0] != '1'
        dialable_phone_number = "+1#{dialable_phone_number}"
      else
        dialable_phone_number = "+#{dialable_phone_number}"
      end
    end

    dialable_phone_number
  end
end