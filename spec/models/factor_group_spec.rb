require 'spec_helper'

describe FactorGroup do
  it_has_a 'valid factory'
  it_validates 'presence of', :symptom
  it_validates 'presence of', :name
  context 'without callbacks' do
    before do
      described_class.any_instance.stub(:set_ordinal)
    end

    it_validates 'presence of', :ordinal
  end
  it_validates 'uniqueness of', :name, :symptom_id
  it_validates 'uniqueness of', :ordinal, :symptom_id
end
