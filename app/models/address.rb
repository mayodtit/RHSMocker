class Address < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :user, inverse_of: :addresses
  has_many :phone_numbers, inverse_of: :address

  attr_accessible :user, :user_id, :address, :address2, :line1, :line2, :city,
                  :state, :postal_code, :name, :type

  validates :user, presence: true

  validates :name, uniqueness: { scope: :user_id }

  alias_attribute :line1, :address
  alias_attribute :line2, :address2
  alias_attribute :type, :name
end
