class Api::V1::AssociationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associations!, only: :index
  before_filter :load_association!, only: [:show, :update, :destroy, :invite]
  before_filter :convert_parameters!, only: [:create, :update]

  def index
    index_resource @associations.serializer
  end

  def show
    show_resource @association.serializer
  end

  def create
    create_resource @user.associations, permitted_params.association
  end

  def update
    update_resource @association, permitted_params.association
  end

  def destroy
    destroy_resource @association
  end

  def invite
    @association.invite!
    show_resource @association.pair.serializer
  end

  private

  def load_associations!
    @associations = @user.associations.enabled
  end

  def load_association!
    @association = @user.associations.find(params[:id])
    authorize! :manage, @association
  end

  def convert_parameters!
    params.require(:association)[:creator_id] = current_user.id unless @association
    if params.require(:association).try(:[], :associate).try(:[], :npi_number)
      if provider = User.find_by_npi_number(params[:association][:associate][:npi_number])
        params[:association].except!(:associate)
        params[:association][:associate_id] = provider.id
      else
        params[:association][:associate] = provider_from_search
        params[:association].change_key!(:associate, :associate_attributes)
      end
    elsif params.require(:association)[:associate]
      params[:association].change_key!(:associate, :associate_attributes)
      params[:association][:associate_attributes][:owner_id] ||= current_user.id
      params[:association][:associate_attributes][:id] = nil if params[:association][:associate_attributes][:id] == 0 # TODO - disable sending fake id from client
    end
  end

  def provider_from_search
    result = search_service.find(params[:association][:associate]).tap do |attributes|
      # TODO: (TS) Pay off this debt - manually adding work_phone_number here is a hack.
      # This should belong in a model somewhere, or at the very least spec-ed, as this can be easily lost
      # if the work_phone_number key is renamed or search_service signature changes
      # Pivotal: https://www.pivotaltracker.com/story/show/64260740
      attributes.merge!(phone: attributes[:address][:phone])
    end
    PermittedParams.new(ActionController::Parameters.new(user: result), current_user).user
  end

  def search_service
    @search_service ||= Search::Service.new
  end
end
