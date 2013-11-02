require 'spec_helper'

describe Symptom do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'presence of', :description
  it_validates 'inclusion of', :patient_type
  it_validates 'allows nil inclusion of', :gender
end

