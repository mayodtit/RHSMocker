class Api::V1::MembersController < Api::V1::ABaseController
  before_filter :load_members!

  def index
    render_success(users: @users,
                   page: page,
                   per: per,
                   total_count: @users.total_count)
  end

  private

  def load_members!
    @users = Member
    @users = @users.name_search(params[:q]) if params[:q]
    @users = @users.page(page).per(per)
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end
end
