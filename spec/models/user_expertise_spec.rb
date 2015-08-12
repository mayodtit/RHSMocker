require 'spec_helper'

describe UserExpertise do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :expertise
  it_validates 'uniqueness of', :expertise_id, :user_id
end
