class Api::V1::MembersController < Api::V1::ABaseController
  before_filter :load_members!, only: :index
  before_filter :load_member!, only: [:show, :update]

  def index
    render_success(users: @users,
                   page: page,
                   per: per,
                   total_count: @users.total_count)
  end

  def show
    authorize! :show, @member
    show_resource @member
  end

  def update
    authorize! :update, @member
    update_resource @member, params[:member]
  end

  private

  def load_members!
    authorize! :index, Member
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

  def load_member!
    @member = Member.find(params[:id])
  end
end
