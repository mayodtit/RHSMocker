class Plan < ActiveRecord::Base
  attr_accessible :name, :description, :price, :stripe_id

  validates :name, :price, :stripe_id, presence: true
end
