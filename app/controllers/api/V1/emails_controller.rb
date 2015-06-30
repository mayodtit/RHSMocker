class Api::V1::EmailsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_user_from_email

  def exists
    if @user
      render_success(exists: true, onboarding_group: onboarding_group)
    else
      render_success(exists: false)
    end
  end

  private

  def load_user_from_email
    @user = Member.find_by_email(params[:email])
  end

  def onboarding_group
    if onboarding_group = @user.onboarding_group
      onboarding_group.serializer(for_onboarding: true).as_json
    else
      nil
    end
  end
end
