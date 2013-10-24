class Api::V1::InvitationsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only => [:show, :update]
  before_filter :load_invitation!, :only => [:show, :update]

  def create
    user_params = params.permit(user: [:email, :first_name, :last_name])[:user]
    user = Member.find_by_email(user_params[:email]) || Member.create(user_params)

    authorize! :assign_roles, user

    if user.signed_up?
      user.add_role :hcp
      UserMailer.assigned_role_email(user, current_user).deliver
      render_success
    else
      if user.valid?
        user.add_role :hcp

        current_user.invitations.create invited_member: user
        render_success
      else
        render_failure({:reason => user.errors.full_messages.to_sentence}, 422)
      end
    end
  end

  def show
    invitation_json = @invitation.as_json(
      :only => [:token],
      :include => {
        :member => {
          :only => [],
          :methods => [:full_name]
        },
        :invited_member => {
          :only => [:email, :first_name, :last_name]
        }
      }
    )

    render_success :invitation => invitation_json
  end

  def update
    user_params = params.permit(:user => [:email, :first_name, :last_name, :password, :password_confirmation])[:user]

    user = @invitation.invited_member
    user.update_attributes user_params

    if user.valid?
      @invitation.claim!
      render_success(:user => user, :auth_token => user.auth_token)
    else
      render_failure({:reason => user.errors.full_messages.to_sentence,
                      :user_message => user.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_invitation!
    @invitation = Invitation.find_by_token!(params[:id])
    raise(ActiveRecord::RecordNotFound) unless @invitation.unclaimed?
  end
end