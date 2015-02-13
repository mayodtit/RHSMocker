class Provider < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :address, :city, :state, :postal_code, :phone

  validates :user, presence: true
  validates :user_id, uniqueness: true
end
