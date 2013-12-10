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
    show_resource @member.as_json(include: [:user_information, :ethnic_group, :diet, :address,
                                            :provider],
                                  methods: [:blood_pressure, :avatar_url, :weight, :admin?,
                                            :nurse?])
  end

  def update
    authorize! :update, @member
    if @member.update_attributes(member_attributes)
      render_success(member: @member.as_json(include: [:user_information, :ethnic_group, :diet, :address,
                                                       :provider],
                                             methods: [:blood_pressure, :avatar_url, :weight, :admin?,
                                                       :nurse?]))
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

  def member_attributes
    params[:member][:user_information_attributes] = params[:member][:user_information].dup
    params[:member][:address_attributes] = params[:member][:address].dup
    params[:member][:provider_attributes] = params[:member][:provider].dup
    params.require(:member).permit(:first_name, :last_name, :phone, :gender,
                                   :birth_date, :ethnic_group_id, :diet_id,
                                   user_information_attributes: [:id, :notes],
                                   address_attributes: [:id, :address, :city, :state, :postal_code],
                                   provider_attributes: [:id, :address, :city, :state, :postal_code, :phone])
  end
end
