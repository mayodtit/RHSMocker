class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, through: :subscriptions

  attr_accessible :name, :description, :price

  validates :name, :description, :price, presence: true
end
