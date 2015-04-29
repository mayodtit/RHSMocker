# We're only supporting US phone numbers for now with no extensions.
# NOTE: Twilio supports dialing extensions (via sendDigits option).
module PhoneNumberUtil
  VALIDATION_REGEX = /\A\d{10}\Z/

  def self.prep_phone_number_for_db(phone_number)
    return nil if phone_number.nil?

    phone_number = phone_number.to_s
    phone_number = phone_number.gsub /[^\d]/, ''

    if phone_number.length == 11 && phone_number[0] == '1'
      phone_number = phone_number[1..-1]
    end

    phone_number
  end

  ## PHONE NUMBER BLACKLIST
  # Assumes phone number is 10-digits
  # def self.is_valid_caller_id(phone_number)
  #   !%(7378742833 0000123456 2562533 8656696 266696687).include? phone_number
  # end

  def self.format_for_dialing(phone_number)
    return nil if phone_number.blank?

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
