class Address < ActiveRecord::Base
  belongs_to :user, inverse_of: :addresses

  attr_accessible :user, :user_id, :address, :address2, :city, :state, :postal_code

  validates :user, presence: true
  validates :user_id, uniqueness: true
end
