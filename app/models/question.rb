class Question < ActiveRecord::Base
  attr_accessible :title, :view

  validates :title, :view, presence: true, uniqueness: true
end
