class Api::V1::InvitationsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only => [:show, :update]
  before_filter :load_invitation!, :only => [:show, :update]
  before_filter :downcase_user_email, :only => [:create, :update]

  def create
    Member.transaction do
      user_params = params.permit(user: [:email, :first_name, :last_name])[:user]
      user = Member.find_by_email(user_params[:email]) || Member.create(user_params)

      authorize! :assign_roles, user

      if user.signed_up?
        add_role user, params[:role]

        url = "#{CARE_URL_PREFIX}/login?next=#{CGI.escape '/settings/profile'}"

        Mails::AssignedRoleJob.create(user.id, url, current_user.full_name)

        render_success
      else
        if user.valid?
          add_role user, params[:role]
          # Resend invitations if one exists for that user.
          invitation = Invitation.find_by_invited_member_id user.id
          if invitation
            invitation.invite_member!
          else
            current_user.invitations.create invited_member: user
          end

          render_success
        else
          render_failure({:reason => user.errors.full_messages.to_sentence}, 422)
        end
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
          :only => [:email, :first_name, :last_name],
          :methods => :nurse?
        }
      }
    )

    render_success :invitation => invitation_json
  end

  def update
    user_params = params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)

    # NOTE: We're doing this automatically and it's the agreement for consumer. MUST BE CHANGED
    user_params[:user_agreements_attributes] = [{agreement_id: Agreement.active.id, ip_address: 'SERVER', user_agent: 'SERVER'}] if Agreement.active

    user = @invitation.invited_member
    user.update_attributes user_params

    if user.valid?
      @invitation.claim!
      @session = user.sessions.create
      render_success(user: user.serializer(include_roles: user.care_provider?), auth_token: @session.auth_token)
    else
      render_failure({:reason => user.errors.full_messages.to_sentence,
                      :user_message => user.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def add_role(user, role)
    if role.nil?
      user.add_role :nurse # accept nil for compatibility
    elsif role
      if role == 'nurse'
        user.add_role :nurse
      elsif role == 'pha'
        user.add_role :pha
      end
    elsif role == 'premium'
      user.cards.create!(resource: CustomCard.find_by_title('Welcome to Better Premium'))
    end
  end

  def load_invitation!
    @invitation = Invitation.where(state: :unclaimed).find_by_token!(params[:id])
  end

  def downcase_user_email
    params[:user][:email].downcase! if params[:user] && params[:user].has_key?(:email)
  end
end
