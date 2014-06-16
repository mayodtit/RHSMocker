class Api::V1::PhaProfilesController < Api::V1::ABaseController
  before_filter :load_pha_profiles!
  before_filter :load_pha_profile!, only: %i(show update)

  def index
    index_resource @pha_profiles.serializer
  end

  def show
    show_resource @pha_profile.serializer
  end

  def create
    create_resource @pha_profiles, permitted_params.pha_profile
  end

  def update
    update_resource @pha_profile, permitted_params.pha_profile
  end

  private

  def load_pha_profiles!
    authorize! :manage, PhaProfile
    @pha_profiles = PhaProfile.scoped
  end

  def load_pha_profile!
    @pha_profile = @pha_profiles.find(params[:id])
    authorize! :manage, @pha_profile
  end
end
