class Api::V1::MembersController < Api::V1::ABaseController
  before_filter :load_members!, only: :index
  before_filter :load_member_from_login!, only: :secure_update

  def index
    render_success(users: @members.includes(:pha).serializer(list: true),
                   page: page,
                   per: per,
                   total_count: @members.total_count)
  end

  def secure_update
    if @member.update_attributes(secure_update_params)
      render_success user: @member.serializer,
                     member: @member.serializer
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_members!
    authorize! :index, Member
    search_params = params.permit(:pha_id, :is_premium, :status)
    if search_params.has_key?(:is_premium) && (search_params[:is_premium] == 'true')
      search_params[:status] = Member::PREMIUM_STATES
      search_params.except!(:is_premium)
    end

    @members = Member.signed_up.where(search_params).order('users.last_contact_at DESC')
    @members = @members.name_search(params[:q]) if params[:q]
    @members = @members.page(page).per(per)
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end

  def load_member_from_login!
    @member = login(current_user.email, current_password)
    render_failure({reason: 'Current password is invalid'}, 422) and return unless @member
    authorize! :manage, @member
  end

  def update_email_path?
    request.env['PATH_INFO'].include?('update_email')
  end

  def update_password_path?
    request.env['PATH_INFO'].include?('update_password')
  end

  def current_password
    if params[:user].try(:[], :current_password)
      params[:user][:current_password]
    elsif update_email_path?
      params[:password]
    elsif update_password_path?
      params[:current_password]
    end
  end

  def secure_update_params
    if update_email_path?
      {
        email: params[:email]
      }
    elsif update_password_path?
      {
        password: params[:password]
      }
    else
      permitted_params(@member).secure_user
    end
  end
end
