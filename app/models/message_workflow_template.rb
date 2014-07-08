class MessageWorkflowTemplate < ActiveRecord::Base
  belongs_to :message_workflow, inverse_of: :message_workflow_templates
  belongs_to :message_template, inverse_of: :message_workflow_templates

  attr_accessible :message_workflow, :message_workflow_id, :message_template,
                  :message_template_id, :days_delayed

  validates :message_workflow, :message_template, :days_delayed, presence: true
end
