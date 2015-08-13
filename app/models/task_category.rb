class TaskCategory < ActiveRecord::Base
  has_many :tasks
  has_many :task_templates
  has_many :task_category_expertises
  has_many :expertises, through: :task_category_expertises

  attr_accessible :title, :description, :priority_weight

  validates :title, :description, :priority_weight, presence: true
end
