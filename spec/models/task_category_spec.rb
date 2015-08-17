require 'spec_helper'

describe TaskCategory do
  it_has_a 'valid factory'
  it_validates 'presence of', :title
  it_validates 'presence of', :priority_weight
end
