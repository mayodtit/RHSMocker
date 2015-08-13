class TaskCategoryExpertise < ActiveRecord::Base
  belongs_to :task_category
  belongs_to :expertise

  attr_accessible :task_category, :task_category_id, :expertise, :expertise_id

  validates :task_category, :expertise, presence: true
  validates :expertise_id, uniqueness: {scope: :task_category_id}
end
