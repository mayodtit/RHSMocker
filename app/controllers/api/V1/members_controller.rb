class Api::V1::MembersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create
  before_filter :load_members!, only: :index
  before_filter :load_member!, only: [:show, :update]
  before_filter :convert_parameters!, only: [:create, :update]

  def index
    render_success(users: @members,
                   page: page,
                   per: per,
                   total_count: @members.total_count)
  end

  def show
    show_resource @member, name: :user
  end

  def current
    show_resource current_user, name: :user
  end

  def create
    @member = Member.create permitted_params.user
    if @member.errors.empty?
      render_success(user: @member, auth_token: @member.auth_token)
    else
      render_failure({reason: @member.errors.full_messages.to_sentence,
                      user_message: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    update_resource @member, permitted_params(@member).user, name: :user
  end

  private

  def load_members!
    authorize! :index, Member
    @members = Member.tap do |members|
                 members.name_search(params[:q]) if params[:q]
               end.page(page).per(per)
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end

  def load_member!
    @member = Member.find(params[:id])
    authorize! :manage, @member
  end

  def convert_parameters!
    params[:user][:avatar] = decode_b64_image(params[:user][:avatar]) if params[:user][:avatar]
    %w(user_information address insurance_policy provider).each do |key|
      params[:user]["#{key}_attributes".to_sym] = params[:user][key.to_sym] if params[:user][key.to_sym]
    end
  end
end
