require 'spec_helper'

describe PlainTextEmailWorkflowTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :message_template
end
