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

  describe '#to_hash_for' do
    let(:user) { build_stubbed(:member) }

    context 'without feature groups' do
      it 'returns the basic metadata' do
        described_class.to_hash_for(user).should == described_class.to_hash
      end
    end

    context 'with feature groups' do
      before(:each) do
        user.stub(:feature_groups => [feature_group])
      end

      context 'without metadata_override' do
        let(:feature_group) { build_stubbed(:feature_group) }

        it 'returns the basic metadata' do
          described_class.to_hash_for(user).should == described_class.to_hash
        end
      end

      context 'with metatadata_override' do
        let(:override) { {:hello => :world} }
        let(:feature_group) { build_stubbed(:feature_group, :metadata_override => override) }

        it 'returns the overridden metadata' do
          described_class.to_hash_for(user).should == described_class.to_hash.merge!(override)
        end
      end
    end
  end
end
