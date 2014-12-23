require 'spec_helper'

describe InsurancePolicy do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
end
