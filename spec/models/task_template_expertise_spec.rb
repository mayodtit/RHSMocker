require 'spec_helper'

describe TaskTemplateExpertise do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_template
  it_validates 'presence of', :expertise
  it_validates 'uniqueness of', :expertise_id, :task_template_id
end
