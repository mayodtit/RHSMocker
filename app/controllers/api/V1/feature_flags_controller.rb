class Api::V1::FeatureFlagsController < Api::V1::ABaseController
  before_filter :load_feauture_flags!

  def index
    index_resource @feature_flags.serializer
  end

  def update
    attributes = []
    update_resource @feature_flags, permitted_params.feature_flags
  end

  private

  def load_feauture_flags!
    authorize! :manage, FeatureFlag
    @feature_flags = FeatureFlag.all
  end
end
