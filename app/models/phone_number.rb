class PhoneNumber < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :number, :type, :primary, :phoneable

  belongs_to :phoneable, polymorphic: true
  validates :phoneable, presence: true

  BLACKLISTED_PHONE_NUMBERS = ["7378742833","0000123456","2562533","8656696","266696687"].freeze
  PHONE_NUMBER_TYPES = %w(Fax Home Work Alternate Mobile NPI Office).freeze

  validates :type, inclusion: { in: PHONE_NUMBER_TYPES, message: "%{value} is not a valid phone number type" }
  validate :parseable_phone_number

  def self.not_blacklisted?(phone_number)
    @blacklist_string ||= BLACKLISTED_PHONE_NUMBERS.join(" ")
    !@blacklist_string.include?(phone_number)
  end

  def not_blacklisted??
    self.class.is_allowable?(number)
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
