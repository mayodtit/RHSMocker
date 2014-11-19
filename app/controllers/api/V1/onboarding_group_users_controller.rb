class Api::V1::OnboardingGroupUsersController < Api::V1::ABaseController
  before_filter :load_onboarding_group!
  before_filter :load_users!, only: %w(index create)
  before_filter :load_user!, only: :destroy

  def index
    index_resource @users.serializer, name: :users
  end

  def create
    @user = @users.create(user_attributes)
    if @user.errors.empty?
       SendMayoPilotInviteEmailService.new(@user).call
      render_success(user: @user.serializer)
    else
      render_failure({reason: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    if @user.update_attributes(onboarding_group: nil)
      render_success
    else
      render_failure({reason: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_onboarding_group!
    @onboarding_group = OnboardingGroup.find(params[:onboarding_group_id])
    authorize! :manage, @onboarding_group
  end

  def load_users!
    @users = @onboarding_group.users
  end

  def load_user!
    @user = @onboarding_group.users.find(params[:id])
  end

  def user_attributes
    params.require(:user).permit(:first_name, :last_name, :email).tap do |attributes|
      attributes[:invitation_token] = invitation_token
    end
  end

  def invitation_token
    Invitation.new.send(:generate_token)
  end
end
