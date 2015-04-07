require 'spec_helper'

describe InsurancePolicyTask do
  it_has_a 'valid factory'
  it_validates 'presence of', :member
  it_validates 'presence of', :subject
end
