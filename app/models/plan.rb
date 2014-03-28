class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, :through => :subscriptions

  attr_accessible :name, :monthly

  validates :name, presence: true, uniqueness: true
  validates :monthly, :inclusion => {:in => [true, false]}
end
