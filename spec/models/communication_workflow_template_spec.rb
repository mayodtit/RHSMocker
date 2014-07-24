require 'spec_helper'

describe CommunicationWorkflowTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :communication_workflow
  it_validates 'presence of', :days_delayed
end
