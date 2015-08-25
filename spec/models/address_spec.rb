require 'spec_helper'

describe Address do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :home
  it_has_a 'valid factory', :work
  it_validates 'foreign key of', :user
  it_validates 'foreign key of', :appointment

  it_validates 'uniqueness of', :name, :user_id
end
