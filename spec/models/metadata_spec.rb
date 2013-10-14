require 'spec_helper'

describe Metadata do
  it_has_a 'valid factory'
  it_validates 'presence of', :key
  it_validates 'presence of', :value
  it_validates 'uniqueness of', :key

  describe '#to_hash' do
    let!(:metadata) { create(:metadata) }

    it 'returns a hash of the key/value pairs' do
      hash = described_class.to_hash
      hash.should be_a(Hash)
      hash[metadata.key].should == metadata.value
    end
  end
end
