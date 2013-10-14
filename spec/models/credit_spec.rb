require 'spec_helper'

describe Credit do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :offering
end
