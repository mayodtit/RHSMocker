require 'spec_helper'

describe MessageWorkflow do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name
end
