class Api::V1::FeatureFlagsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :index
  before_filter :load_feature_flags!, only: :index
  before_filter :load_feature_flag!, only: [:update, :show]

  def index
    index_resource @feature_flags.serializer
  end

  def show
    show_resource @feature_flag.serializer
  end

  def update
    authorize! :manage, FeatureFlag
    feature_flag_params = permitted_params.feature_flag
    feature_flag_params[:actor_id] =  current_user.id if current_user

    update_resource @feature_flag, feature_flag_params
  end

  private

  def load_feature_flags!
    @feature_flags = FeatureFlag.where(disabled_at: nil)
  end

  def load_feature_flag!
    @feature_flag = FeatureFlag.find_by_mkey(params[:id])
  end
end
