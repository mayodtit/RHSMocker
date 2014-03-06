require 'spec_helper'

describe UserRole do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :role
  it_validates 'uniqueness of', :role_id, :user_id
end
