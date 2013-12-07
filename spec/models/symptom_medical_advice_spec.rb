require 'spec_helper'

describe SymptomMedicalAdvice do
  it_has_a 'valid factory'
  it_validates 'presence of', :symptom
  it_validates 'presence of', :description
end
