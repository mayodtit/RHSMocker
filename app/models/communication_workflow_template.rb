class CommunicationWorkflowTemplate < ActiveRecord::Base
  belongs_to :communication_workflow, inverse_of: :communication_workflow_templates

  attr_accessible :communication_workflow, :communication_workflow_id,
                  :days_delayed

  validates :communication_workflow, :days_delayed, presence: true
end
