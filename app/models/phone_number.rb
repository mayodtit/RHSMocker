class PhoneNumber < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :number, :type

  belongs_to :phoneable, polymorphic: true
  validates :phoneable, presence: true

  validates :type, inclusion: { in: %w(NPI Fax Home Mobile Office Alternate), message: "%{value} is not a valid phone number type" }
  validate :parseable_phone_number

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
