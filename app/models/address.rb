class Address < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :user, inverse_of: :addresses

  attr_accessible :user, :user_id, :address, :address2, :line1, :line2, :city,
                  :state, :postal_code, :type

  validates :user, presence: true

  alias_attribute :line1, :address
  alias_attribute :line2, :address2
end
