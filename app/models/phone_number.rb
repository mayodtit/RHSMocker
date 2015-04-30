class PhoneNumber < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :number, :type, :primary, :phoneable

  belongs_to :phoneable, polymorphic: true
  validates :phoneable, presence: true

  VALIDATION_REGEX = /\A\d{10}\Z/
  BLACKLISTED_PHONE_NUMBERS = ["7378742833","0000123456","2562533","8656696","266696687"].freeze
  PHONE_NUMBER_TYPES = %w(Fax Home Work Alternate Mobile NPI Office).freeze

  validates :type, inclusion: { in: PHONE_NUMBER_TYPES, message: "%{value} is not a valid phone number type" }
  validate :parseable_phone_number

  def self.not_blacklisted?(phone_number)
    @blacklist_string ||= BLACKLISTED_PHONE_NUMBERS.join(" ")
    !@blacklist_string.include?(phone_number)
  end

  def not_blacklisted?
    self.class.not_blacklisted?(number)
  end

  def self.prep_phone_number_for_db(phone_number)
    return nil if phone_number.nil?

    phone_number = phone_number.to_s.gsub /[^\d]/, ''

    if phone_number.length == 11 && phone_number[0] == '1'
      phone_number = phone_number[1..-1]
    end

    phone_number
  end

  def prep_phone_number_for_db
    self.class.prep_phone_number_for_db(number)
  end

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

  def format_for_dialing
    self.class.format_for_dialing(number)
  end

  def parseable_phone_number
    begin
      unless Phoner::Phone.parse(number)
        errors.add(:number, "is invalid")
      end
    rescue
      errors.add(:number, "is invalid")
    end
  end

  def display
    phone.format("(%a) %f-%l")
  end

  private

  def phone
    begin
      @phone_number ||= Phoner::Phone.parse(number)
    rescue
    end
  end
end
