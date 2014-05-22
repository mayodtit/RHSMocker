require 'spec_helper'

describe UserRequest do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :subject
  it_validates 'presence of', :name
end
