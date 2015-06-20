require 'spec_helper'

describe TaskDataField do
  it_has_a 'valid factory'
  it_validates 'presence of', :task
  it_validates 'presence of', :data_field
  it_validates 'presence of', :task_data_field_template
end
