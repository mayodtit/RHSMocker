class InvitesController < ApplicationController
  before_filter :load_member!, :only => [:show, :update]

  def show
    redirect_to signup_invites_url and return unless @member
    redirect_to :complete and return if @member.password
    render :show
  end

  def update
    if @member.update_attributes(params[:user])
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
end
