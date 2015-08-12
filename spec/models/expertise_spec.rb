require 'spec_helper'

describe Expertise do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name, :resource_id, :resource_type
end
