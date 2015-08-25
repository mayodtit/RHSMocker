class Address < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :user, inverse_of: :addresses
  belongs_to :appointment, inverse_of: :address
  has_many :phone_numbers, as: :phoneable

  attr_accessible :user, :user_id, :address, :address2, :line1, :line2, :city,
                  :state, :postal_code, :name, :type, :appointment, :appointment_id

  validates :user, presence: true, if: lambda { |a| a.user_id }
  validates :appointment, presence: true, if: lambda { |a| a.appointment_id }

  validates :name, uniqueness: { scope: :user_id }, if: :user_id

  alias_attribute :line1, :address
  alias_attribute :line2, :address2
  alias_attribute :type, :name
end
