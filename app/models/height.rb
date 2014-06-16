class Height < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :amount, :taken_at

  validates :user, :amount, :taken_at, presence: true
end
