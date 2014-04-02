class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, through: :subscriptions

  attr_accessible :name, :description, :price, :stripe_id

  validates :name, :price, :stripe_id, presence: true
end
