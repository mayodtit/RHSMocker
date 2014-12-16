require 'spec_helper'

describe Guide do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_template
  it_validates 'presence of', :description
end
