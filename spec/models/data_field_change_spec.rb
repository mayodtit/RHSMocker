require 'spec_helper'

describe DataFieldChange do
  it_has_a 'valid factory'
  it_validates 'presence of', :data_field
  it_validates 'presence of', :actor
  it_validates 'presence of', :data
end
