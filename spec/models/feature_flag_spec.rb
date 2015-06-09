require 'spec_helper'

describe FeatureFlag do
  it_has_a 'valid factory'

  describe '#feature_enabled?' do
    let!(:feature_flag) { create :feature_flag, mvalue: 'true' }

    it 'returns true if the feature is enabled' do
      feature_flag.feature_enabled?.should be_true
    end
  end
end
