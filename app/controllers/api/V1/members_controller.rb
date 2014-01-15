class Api::V1::MembersController < Api::V1::ABaseController
  before_filter :load_members!, only: :index
  before_filter :load_member!, only: [:show, :update]
  before_filter :convert_nested_attributes!, only: :update

  def index
    render_success(users: @users,
                   page: page,
                   per: per,
                   total_count: @users.total_count)
  end

  def show
    authorize! :show, @member
    show_resource member_json
  end

  def update
    authorize! :update, @member
    if @member.update_attributes(member_attributes)
      render_success(member: member_json)
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
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

  def convert_nested_attributes!
    %w(user_information address insurance_policy provider).each do |key|
      params[:member]["#{key}_attributes".to_sym] = params[:member][key.to_sym]
    end
  end

  def member_attributes
    params.require(:member).permit(:first_name, :last_name, :phone, :gender,
                                   :birth_date, :ethnic_group_id, :diet_id,
                                   :nickname,
                                   user_information_attributes: [:id, :notes],
                                   address_attributes: [:id, :address, :city, :state, :postal_code],
                                   insurance_policy_attributes: [:id, :company_name, :plan_type, :policy_member_id],
                                   provider_attributes: [:id, :address, :city, :state, :postal_code, :phone])
  end

  def member_json
    @member.as_json(include: [:user_information, :ethnic_group, :diet, :address,
                              :insurance_policy, :provider],
                    methods: [:blood_pressure, :avatar_url, :weight, :admin?,
                              :nurse?])
  end
end
