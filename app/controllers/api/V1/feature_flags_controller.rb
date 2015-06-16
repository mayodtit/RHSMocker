class Api::V1::FeatureFlagsController < Api::V1::ABaseController
  before_filter :load_feature_flags!, only: :index
  before_filter :load_feature_flag!, only: [:update, :show]

  def index
    index_resource @feature_flags.serializer
  end

  def show
    show_resource @feature_flag.serializer
  end

  def update
    feature_flag_params = permitted_params.feature_flag
    feature_flag_params[:actor_id] =  current_user.id if current_user

    update_resource @feature_flag, feature_flag_params
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
