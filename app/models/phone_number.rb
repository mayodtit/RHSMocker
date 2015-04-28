class PhoneNumber < ActiveRecord::Base
  attr_accessible :address_id, :number, :type, :user_id

  belongs_to :user, inverse_of: :phone_numbers
  belongs_to :address, inverse_of: :phone_numbers

  validates :type, inclusion: { in: %w(NPI Fax Home OFfice Alternate), message: "%{value} is not a valid phone number type" }
  validate :must_belong_to_user_or_address

  def must_belong_to_user_or_address
    unless user || address
      unless user
        errors.add(:user, "or address must be assigned")
      end
      unless address
        errors.add(:address, "or user must be assigned")
      end
    end
  end

  def display
    phone.format("(%a) %f-%l")
  end

  private

  def phone
    @phone_number ||= Phoner::Phone.parse(number)
  end
end
