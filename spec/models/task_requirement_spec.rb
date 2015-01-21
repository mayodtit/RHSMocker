require 'spec_helper'

describe TaskRequirement do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_requirement_template
  it_validates 'presence of', :title
end
