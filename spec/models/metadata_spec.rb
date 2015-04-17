require 'spec_helper'

describe Metadata do
  before do
    @pha_lead = Role.find_or_create_by_name :pha_lead
  end

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
    let(:user_hash) { {current_user: user.serializer.as_json} }

    context 'without feature groups' do
      it 'returns the basic metadata with current_user' do
        described_class.to_hash_for(user).should == described_class.to_hash.merge(user_hash)
      end
    end

    context 'with feature groups' do
      before do
        user.stub(feature_groups: [feature_group])
        user.stub_chain(:feature_groups, :find_by_name).and_return(nil)
      end

      context 'without metadata_override' do
        let(:feature_group) { build_stubbed(:feature_group) }

        it 'returns the basic metadata' do
          described_class.to_hash_for(user).should == described_class.to_hash.merge(user_hash)
        end
      end

      context 'with metatadata_override' do
        let(:override) { {hello: :world} }
        let(:feature_group) { build_stubbed(:feature_group, metadata_override: override) }

        it 'returns the overridden metadata' do
          described_class.to_hash_for(user).should == described_class.to_hash.merge!(override).merge!(user_hash)
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

  describe '#outbound_calls_number' do
    it_behaves_like 'has a default value', :outbound_calls_number
  end

  describe '#force_phas_off_call' do
    context 'mkey not found' do
      it 'returns false' do
        Metadata.should_not be_force_phas_off_call
      end
    end

    context 'mkey found' do
      it 'is false' do
        m = create(:metadata, mkey: 'force_phas_off_call', mvalue: 'false')
        Metadata.should_not be_force_phas_off_call
      end

      context 'value is true' do
        it 'is true' do
          m = create(:metadata, mkey: 'force_phas_off_call', mvalue: 'true')
          Metadata.should be_force_phas_off_call
        end
      end
    end
  end

  describe '#offboard_free_trial_start_date' do
    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'metadata exists' do
      context 'an exception happens during parsing' do
        let!(:meta_data) { Metadata.create! mkey: 'offboard_free_trial_start_date', mvalue: '01/30' }

        it 'returns 1 year from now' do
          Metadata.offboard_free_trial_start_date.should == 1.year.from_now
        end
      end

      context 'metadata is correctly formatted' do
        let!(:meta_data) { Metadata.create! mkey: 'offboard_free_trial_start_date', mvalue: '01/30/1985' }

        it 'returns 1/30/1985' do
          Metadata.offboard_free_trial_start_date.should == Time.parse('30/01/1985')
        end
      end
    end

    context 'metadata is missing' do
      it 'returns 1 year from now' do
        Metadata.offboard_free_trial_start_date.should == 1.year.from_now
      end
    end
  end

  describe '#notify_lack_of_tasks' do
    context 'mkey not found' do
      it 'returns false' do
        Metadata.should_not be_notify_lack_of_tasks
      end
    end

    context 'mkey found' do
      it 'is false' do
        m = create(:metadata, mkey: 'notify_lack_of_tasks', mvalue: 'false')
        Metadata.should_not be_notify_lack_of_tasks
      end

      context 'value is true' do
        it 'is true' do
          m = create(:metadata, mkey: 'notify_lack_of_tasks', mvalue: 'true')
          Metadata.should be_notify_lack_of_tasks
        end
      end
    end
  end
end
