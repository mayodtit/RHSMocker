require 'spec_helper'

describe Metadata do
  it_has_a 'valid factory'
  it_validates 'presence of', :mkey
  it_validates 'presence of', :mvalue
  it_validates 'uniqueness of', :mkey

  describe '#to_hash' do
    let!(:metadata) { create(:metadata) }

    it 'returns a hash of the key/value pairs' do
      hash = described_class.to_hash
      hash.should be_a(Hash)
      hash[metadata.mkey].should == metadata.mvalue
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

  describe '#use_invite_flow?' do
    context 'without use_invite_flow Metadata object' do
      it 'should return false' do
        expect(Metadata.use_invite_flow?).to be_false
      end
    end

    context 'with use_invite_flow Metadata object' do
      it 'should return the value of use_invite_flow' do
        m = create(:metadata, mkey: 'use_invite_flow', mvalue: 'false')
        expect(Metadata.use_invite_flow?).to be_false
        m.update_attributes(mvalue: 'true')
        expect(Metadata.use_invite_flow?).to be_true
      end
    end
  end

  shared_examples 'has a default value' do |attr|
    context 'mkey not found' do
      it 'returns the default constant value' do
        Metadata.send(attr).should == Object.const_get(attr.upcase)
      end
    end

    context 'mkey found' do
      it 'returns the DB value' do
        m = create(:metadata, mkey: attr, mvalue: '23423423523')
        Metadata.send(attr).should == '23423423523'
      end
    end
  end

  describe '#nurse_phone_number' do
    it_behaves_like 'has a default value', :nurse_phone_number
  end

  describe '#pha_phone_number' do
    it_behaves_like 'has a default value', :pha_phone_number
  end
end
