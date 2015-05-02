class ProviderCallLog < ActiveRecord::Base
  attr_accessible :npi, :number, :user_id

  belongs_to :user

  validates_presence_of :npi
  validates :number, format: PhoneNumber::VALIDATION_REGEX, allow_blank: false
  validates_presence_of :user_id
end
