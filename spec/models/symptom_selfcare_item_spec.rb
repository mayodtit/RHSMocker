require 'spec_helper'

describe SymptomSelfcareItem do
  it_has_a 'valid factory'
  it_validates 'presence of', :symptom_selfcare
  it_validates 'presence of', :description
end
