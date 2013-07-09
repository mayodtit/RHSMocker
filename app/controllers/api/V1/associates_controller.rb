class Api::V1::AssociatesController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :first_name, :last_name, :npi_number, :expertise, :city, :state

  before_filter :load_user!
  before_filter :load_association!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.associates)
  end

  def show
    show_resource(@association)
  end

  def create
    create_resource(@user.associations, association_params)
  end

  def update
    update_resource(@association, association_params)
  end

  def destroy
    destroy_resource(@association)
  end

  private

  def load_user!
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    authorize! :manage, @user
  end

  def load_association!
    @association = @user.associations.find_by_associate_id!(associate_id: params[:id])
    authorize! :manage, @association.associate
  end

  def association_params
    hash = if params[:associate][:npi_number]
             npi_user = User.find_by_npi_number(params[:associate][:npi_number])
             npi_user ? {associate: npi_user} : {associate_attributes: sanitize_for_mass_assignment(search_service.find(params[:associate][:npi_number]))}
           else
             {associate_attributes: sanitize_for_mass_assignment(params[:associate])}
           end
    hash[:association_type_id] = params[:associate][:association_type_id] if params[:associate][:association_type_id]
    hash
  end

  def search_service
    @search_service ||= Search::Service.new
  end
end
