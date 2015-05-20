class ModalTemplate < ActiveRecord::Base
  has_many :tasks
  has_many :task_templates

  attr_accessible :title, :description, :accept, :reject
  validates :title, presence: true
end
