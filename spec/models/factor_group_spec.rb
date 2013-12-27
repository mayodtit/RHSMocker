require 'spec_helper'

describe FactorGroup do
  it_has_a 'valid factory'
  it_validates 'presence of', :symptom
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name, :symptom_id
end
