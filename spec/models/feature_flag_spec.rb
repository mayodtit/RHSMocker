require 'spec_helper'

describe FeatureFlag do
  it_has_a 'valid factory'

  describe '#feature_enabled?' do
    let!(:feature_flag) { create :feature_flag, mvalue: 'true' }

    it 'returns true if the feature is enabled' do
      feature_flag.feature_enabled?.should be_true
    end
  end

  describe '#track_update' do
    let!(:feature_flag) { create :feature_flag, mvalue: 'false'}

    before do
      FeatureFlagChange.destroy_all
    end

    context 'nothing changed' do
      context 'because no changes were made' do
        it 'does nothing' do
          FeatureFlagChange.should_not_receive(:create!)
          feature_flag.send(:track_update)
        end
      end

      context 'because only created_at and updated_at were changed' do
        it 'does nothing' do
          feature_flag.created_at = 4.days.ago
          feature_flag.updated_at = 3.days.ago
          feature_flag.changes.should_not be_empty
          FeatureFlagChange.should_not_receive(:create!)
          feature_flag.send(:track_update)
        end
      end
    end

    context 'something changed' do
      it 'it tracks a change after a feature flag is toggled' do
        old_value = feature_flag.mvalue
        feature_flag.update_attributes!(mvalue: 'true')
        FeatureFlagChange.count.should == 1
        f = FeatureFlagChange.last
        f.feature_flag.should == feature_flag
        f.actor.should == Member.robot
        f.action.should == 'update'
        f.data.should == {"mvalue" => [old_value, 'true']}
      end

      context 'actor_id is defined' do
        let(:super_admin) { build_stubbed :super_admin }

        before do
          feature_flag.actor_id = super_admin.id
          feature_flag.mvalue = 'true'
        end

        it 'uses the defined actor id' do
          FeatureFlagChange.should_receive(:create!).with hash_including(actor_id: super_admin.id)
          feature_flag.send(:track_update)
        end
      end
    end
  end
end
