class Expertise < ActiveRecord::Base
  has_many :user_expertises
  has_many :users, through: :user_expertises
  has_many :task_template_expertises
  has_many :task_templates, through: :task_template_expertises
  has_many :task_category_expertises
  has_many :task_catgories, through: :task_category_expertises

  attr_accessible :name

  validates :name, presence: true
end
