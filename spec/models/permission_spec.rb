require 'spec_helper'

describe Permission do
  it_has_a 'valid factory'
  it_validates 'presence of', :subject
  it_validates 'uniqueness of', :subject_id
end
