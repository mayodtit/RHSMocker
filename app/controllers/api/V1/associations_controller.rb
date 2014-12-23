class Api::V1::AssociationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associations!, only: :index
  before_filter :load_association!, only: [:show, :update, :destroy, :invite]
  before_filter :verify_associate!, only: :create
  before_filter :verify_creator_permission!, only: :create
  before_filter :convert_parameters!, only: [:create, :update]

  def index
    render_success(associations: @associations.serializer(serializer_options),
                   permissions: @associations.map(&:permission).serializer)
  end

  def show
    render_success(association: @association.serializer(serializer_options),
                   permissions: [@association.permission].serializer)
  end

  def create
    @association = @user.associations.create(permitted_params.association)
    if @association.errors.empty?
      render_success(association: @association.serializer(serializer_options),
                     permissions: [@association.permission].serializer)
    else
      render_failure({reason: @association.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    if @association.update_attributes(permitted_params.association)
      render_success({association: @association.serializer(serializer_options),
                      permissions: [@association.permission].serializer.as_json}.tap do |hash|
                       hash.merge!(users: [@association.user.serializer, @association.associate.serializer]) unless @association.association_type.try(:hcp?)
                       hash.merge!(inverse_association: @association.pair.serializer) if @association.pair
                       hash[:permissions] << @association.pair.permission.serializer if @association.pair
                       hash.merge!(parent_association: @association.parent.serializer) if @association.parent
                       hash[:permissions] << @association.parent.permission.serializer if @association.parent
                     end)
    else
      render_failure({reason: @association.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    @association.actor_id = current_user.id
    destroy_resource @association
  end

  def invite
    @association.invite!
    render_success(association: @association.pair.serializer,
                   permissions: [@association.pair.permission].serializer)
  end

  private

  def load_associations!
    @associations = if params[:state] == 'pending'
                      @user.associations.pending.includes(:permission)
                    else
                      @user.associations.enabled.includes(:permission)
                    end
  end

  def load_association!
    @association = @user.associations.find(params[:id])
    authorize! :manage, @association
  end

  def verify_associate!
    if params[:association][:associate_id]
      @associate = User.find(params[:association][:associate_id])
      raise CanCan::AccessDenied unless @associate.owner_id == current_user.id
      raise CanCan::AccessDenied if Association.where(user_id: @associate.owner_id, associate_id: @associate.id).first.try(:replacement)
    end
  end

  def verify_creator_permission!
    if @associate
      raise CanCan::AccessDenied if (current_user != @user) && (current_user != @associate) && (current_user != @associate.owner)
    end
  end

  def convert_parameters!
    address = params[:association].try(:[], :associate).try(:[], :address)

    params.require(:association)[:creator_id] = current_user.id unless @association
    if params.require(:association).try(:[], :associate).try(:[], :npi_number)
      if provider = User.find_by_npi_number(params[:association][:associate][:npi_number])
        params[:association].except!(:associate)
        params[:association][:associate_id] = provider.id
      else
        params[:association][:associate] = provider_from_search
        params[:association].change_key!(:associate, :associate_attributes)
        add_address_attributes(address)
      end
    elsif params.require(:association)[:associate]
      params[:association].change_key!(:associate, :associate_attributes)
      if AssociationType.find_by_id(params[:association][:association_type_id]).try(:relationship_type) == 'hcp'
        params[:association][:associate_attributes][:self_owner] ||= true
      else
        params[:association][:associate_attributes][:owner_id] ||= @user.id
      end
      params[:association][:associate_attributes][:id] = nil if params[:association][:associate_attributes][:id] == 0 # TODO - disable sending fake id from client
      add_address_attributes(address)
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

  # Add in address attributes for both NPI and non-NPI providers.
  # In the future we may auto-populate the address for NPI providers based on Bloom search results.
  def add_address_attributes(address)
    params[:association][:associate_attributes][:addresses_attributes] = [address] if address
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(scope: current_user)
      options.merge!(include_nested_information: true) if current_user.care_provider?
    end
  end
end
