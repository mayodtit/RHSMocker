class Expertise < ActiveRecord::Base
  has_many :user_expertises
  has_many :users, through: :user_expertises
  has_many :task_templates
  has_many :task_categories

  attr_accessible :name

  validates :name, presence: true, uniqueness: true
end
