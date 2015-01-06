require 'spec_helper'

describe TaskGuide do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_template
  it_validates 'presence of', :title
end
