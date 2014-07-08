class MessageWorkflow < ActiveRecord::Base
  has_many :message_workflow_templates, inverse_of: :message_workflow
  has_many :message_templates, through: :message_workflow_templates

  attr_accessible :name

  validates :name, presence: true, uniqueness: true
end
