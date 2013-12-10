class Address < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :address, :city, :state, :postal_code

  validates :user, presence: true
  validates :user_id, uniqueness: true
end
