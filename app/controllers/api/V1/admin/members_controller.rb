# TODO - this is a temporary class until ability is cleaned up
class Api::V1::Admin::MembersController < Api::V1::ABaseController
  before_filter :authorize_admin!
  before_filter :load_members!
  before_filter :load_member!, only: %i(show update)

  def index
    index_resource @members.serializer, name: :users
  end

  def show
    show_resource @member.serializer, name: :user
  end

  def update
    update_resource @member, user_attributes, name: :user
  end

  private

  def authorize_admin!
    raise CanCan::AccessDenied unless current_user.admin?
  end

  def load_members!
    @members = Member.scoped
  end

  def load_member!
    @member = @members.find(params[:id])
  end

  def user_attributes
    params.require(:user).permit(:is_premium, :free_trial_ends_at, :pha_id)
  end
end
