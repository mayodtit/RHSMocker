class Api::V1::OnboardingGroupsController < Api::V1::ABaseController
  before_filter :load_onboarding_groups!, only: %i(index create)
  before_filter :load_onboarding_group!, only: %i(show update)

  def index
    index_resource @onboarding_groups.serializer.as_json.each{|o| o[:users_count] = onboarding_group_counts[o[:id]] || 0}
  end

  def show
    show_resource @onboarding_group.serializer
  end

  def create
    create_resource @onboarding_groups, permitted_params.onboarding_group
  end

  def update
    update_resource @onboarding_group, permitted_params.onboarding_group
  end

  private

  def load_onboarding_groups!
    authorize! :manage, OnboardingGroup
    @onboarding_groups = OnboardingGroup.includes(:provider)
  end

  def load_onboarding_group!
    @onboarding_group = OnboardingGroup.find(params[:id])
    authorize! :manage, @onboarding_group
  end

  def onboarding_group_counts
    @onboarding_group_counts ||= Member.group(:onboarding_group_id).count
  end
end
