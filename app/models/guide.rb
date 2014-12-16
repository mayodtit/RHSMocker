class Guide < ActiveRecord::Base
  belongs_to :task_template

  attr_accessible :task_template, :task_template_id, :description

  validates :task_template, :description, presence: true
end
