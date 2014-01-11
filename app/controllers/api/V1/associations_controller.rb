class Api::V1::AssociationsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :first_name, :last_name, :npi_number, :expertise, :city, :state, :avatar,
                  :birth_date, :phone, :blood_type, :holds_phone_in, :diet_id, :ethnic_group_id,
                  :deceased, :date_of_death, :units, :gender, :height

  before_filter :load_user!
  before_filter :load_association!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.associations)
  end

  def show
    show_resource(@association)
  end

  def create
    create_resource(@user.associations, association_params)
  end

  def update
    update_resource(@association, update_association_attributes)
  end

  def destroy
    destroy_resource(@association)
  end

  private

  def load_association!
    @association = @user.associations.find(params[:id])
    authorize! :manage, @association.associate
  end

  def association_params
    hash = if params[:association][:associate][:npi_number]
             npi_user = User.find_by_npi_number(params[:association][:associate][:npi_number])
             npi_user ? {associate: npi_user} : {associate_attributes: sanitize_for_mass_assignment(search_service.find(params[:association][:associate]))}
           else
             {associate_attributes: sanitize_for_mass_assignment(params[:association][:associate])}
           end
    hash[:association_type_id] = params[:association][:association_type_id]

    if hash[:associate_attributes].try(:[], :avatar).present?
      v = decode_b64_image(hash[:associate_attributes][:avatar])
      hash[:associate_attributes][:avatar] = v
    end

    hash
  end

  def update_association_attributes
    params.require(:association).permit(:association_type_id)
  end

  def search_service
    @search_service ||= Search::Service.new
  end
end
