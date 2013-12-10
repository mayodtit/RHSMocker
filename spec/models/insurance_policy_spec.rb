require 'spec_helper'

describe InsurancePolicy do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'uniqueness of', :user_id
end
