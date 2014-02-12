class Api::V1::AssociationsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :first_name, :last_name, :npi_number, :expertise, :city, :state, :avatar,
                  :birth_date, :phone, :blood_type, :holds_phone_in, :diet_id, :ethnic_group_id,
                  :deceased, :date_of_death, :units, :gender, :height, :email, :nickname,
                  :provider_taxonomy_code

  before_filter :load_user!
  before_filter :load_associations!, only: :index
  before_filter :load_association!, only: [:show, :update, :destroy, :invite]

  def index
    index_resource @associations.serializer
  end

  def show
    show_resource(@association.serializer)
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

  def invite
    @association.invite!
    render_success
  end

  private

  def load_associations!
    @associations = @user.associations.enabled
  end

  def load_association!
    @association = @user.associations.find(params[:id])
    authorize! :manage, @association
  end

  def association_params
    hash = if params[:association][:associate][:npi_number]
             npi_user = User.find_by_npi_number(params[:association][:associate][:npi_number])
             if npi_user
               {associate: npi_user}
             else
               search_result = search_service.find(params[:association][:associate])

               # TODO: (TS) Pay off this debt - manually adding work_phone_number here is a hack.
               # This should belong in a model somewhere, or at the very least spec-ed, as this can be easily lost
               # if the work_phone_number key is renamed or search_service signature changes
               # Pivotal: https://www.pivotaltracker.com/story/show/64260740
               associate_attribs = sanitize_for_mass_assignment(search_result).merge({phone: search_result[:address][:phone]})

               {associate_attributes: associate_attribs}
             end
           else
             {associate_attributes: sanitize_for_mass_assignment(params[:association][:associate])}
           end
    hash[:association_type_id] = params[:association][:association_type_id]

    if hash[:associate_attributes].try(:[], :avatar).present?
      v = decode_b64_image(hash[:associate_attributes][:avatar])
      hash[:associate_attributes][:avatar] = v
    end

    hash.merge!(default_hcp: params[:default_hcp]) if params[:default_hcp]
    hash
  end

  def update_association_attributes
    p = params.require(:association).permit(:association_type_id)
    p.merge!(default_hcp: params[:default_hcp]) if params[:default_hcp]
    p
  end

  def search_service
    @search_service ||= Search::Service.new
  end
end
