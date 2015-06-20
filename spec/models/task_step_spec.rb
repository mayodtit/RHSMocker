require 'spec_helper'

describe TaskStep do
  it_has_a 'valid factory'
  it_validates 'presence of', :task
  it_validates 'presence of', :task_step_template
  it_validates 'inclusion of', :completed
end
