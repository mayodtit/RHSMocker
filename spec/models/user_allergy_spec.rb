require 'spec_helper'

describe UserAllergy do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :allergy
  it_validates 'scoped uniqueness of', :allergy_id, :user_id
end
