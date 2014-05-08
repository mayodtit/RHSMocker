class InvitesController < ApplicationController
  layout 'public_page_layout'
  before_filter :load_member!, :only => [:show, :update]
  before_filter :convert_parameters!, only: %i(update)

  def show
    redirect_to signup_invites_url and return unless @member
    redirect_to :complete and return if @member.password
    render :show
  end

  def update
    if @member.update_attributes(permitted_params.user)
      @member.update_attribute(:invitation_token, nil)
      redirect_to complete_invites_url
    else
      render action: :show
    end
  end

  def complete
    render :complete
  end

  def signup
    render :signup
  end

  private

  def load_member!
    @member = Member.find_by_invitation_token(params[:id])
  end

  def convert_parameters!
    user_params[:user_agreements_attributes] = user_agreements_attributes if user_params[:tos_checked] || user_params[:agreement_id]
  end

  def user_agreements_attributes
    return [] unless Agreement.active
    if user_params[:agreement_id]
      [
        {
          agreement_id: user_params[:agreement_id],
          ip_address: request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT']
        }
      ]
    elsif user_params[:tos_checked] && Metadata.allow_tos_checked?
      [
        {
          agreement_id: Agreement.active.id,
          ip_address: request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT']
        }
      ]
    end
  end

  def user_params
    params.require(:user)
  end
end
