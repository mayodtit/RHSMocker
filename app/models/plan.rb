class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, through: :subscriptions

  attr_accessible :name

  validates :name, presence: true
end
