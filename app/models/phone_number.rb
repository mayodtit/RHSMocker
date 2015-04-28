class PhoneNumber < ActiveRecord::Base
  attr_accessible :address_id, :number, :type, :user_id

  belongs_to :user, inverse_of: :phone_numbers
  belongs_to :address, inverse_of: :phone_numbers

  validates :type, inclusion: { in: %w(NPI Fax Home OFfice Alternate), message: "%{value} is not a valid phone number type" }

end
