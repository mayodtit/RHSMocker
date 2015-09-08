class Api::V1::OnboardingGroupCandidatesController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_onboarding_group!

  def create
    create_resource @onboarding_group.onboarding_group_candidates, action_params
  end

  private

  def load_onboarding_group!
    @onboarding_group = OnboardingGroup.find(params[:onboarding_group_id])
  end

  def action_params
    params.require(:user).permit(:first_name, :email, :phone, :surgery_date, :surgery_time, :notes)
  end
end
