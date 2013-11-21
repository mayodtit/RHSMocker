require 'spec_helper'

describe ContentsSymptomsFactor do
  it_has_a 'valid factory'
  it_validates 'presence of', :content
  it_validates 'presence of', :symptoms_factor
  it_validates 'uniqueness of', :content_id, :symptoms_factor_id
end
