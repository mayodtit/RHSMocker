require 'spec_helper'

describe SymptomsFactor do
  it_has_a 'valid factory'
  it_validates 'presence of', :symptom
  it_validates 'presence of', :factor
  it_validates 'presence of', :factor_group
  it_validates 'uniqueness of', :factor_id, :symptom_id, :factor_group_id
end
