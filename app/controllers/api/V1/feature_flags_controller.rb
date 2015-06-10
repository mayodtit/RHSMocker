class Api::V1::FeatureFlagsController < Api::V1::ABaseController
  before_filter :load_feature_flags!, only: :index
  before_filter :load_feature_flag!, only: :update

  def index
    index_resource @feature_flags.serializer
  end

  def update
    permitted_params.feature_flag[:actor_id] = current_user.id if current_user
    update_resource @feature_flag, permitted_params.feature_flag
  end

  private

  def load_feature_flags!
    authorize! :manage, FeatureFlag
    @feature_flags = FeatureFlag.where(disabled_at: nil)
  end

  def load_feature_flag!
    authorize! :manage, FeatureFlag
    @feature_flag = FeatureFlag.find(params[:id])
  end
end
