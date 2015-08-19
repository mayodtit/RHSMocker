class TaskCategory < ActiveRecord::Base
  belongs_to :expertise
  has_many :tasks
  has_many :task_templates

  attr_accessible :title, :description, :priority_weight, :expertise, :expertise_id

  validates :title, :description, :priority_weight, presence: true
  validates :expertise, presence: true, if: lambda { |t| t.expertise_id }
end
