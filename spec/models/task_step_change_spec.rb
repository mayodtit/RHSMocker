require 'spec_helper'

describe TaskStepChange do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_step
  it_validates 'presence of', :actor
  it_validates 'presence of', :data
end
