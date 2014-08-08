require 'spec_helper'

describe SystemMessageWorkflowTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :message_template
end
