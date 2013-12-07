require 'spec_helper'

describe SymptomMedicalAdviceItem do
  it_has_a 'valid factory'
  it_validates 'presence of', :symptom_medical_advice
  it_validates 'presence of', :description
end
