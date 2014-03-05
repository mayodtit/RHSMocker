require 'spec_helper'

describe EmergencyContact do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_designee
  it_validates 'presence of', :user
  it_validates 'uniqueness of', :user_id
  it_validates 'foreign key of', :designee
end
