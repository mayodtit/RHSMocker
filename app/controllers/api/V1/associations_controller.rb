class Api::V1::AssociationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_associations!, only: :index
  before_filter :load_association!, only: %i(show update destroy invite)
  before_filter :verify_associate!, only: :create
  before_filter :verify_creator_permission!, only: :create
  before_filter :set_creator!, only: :create
  before_filter :set_owner!, only: :create
  before_filter :convert_parameters!, only: %i(create update)
  before_filter :unset_android_id_zero!, only: %i(create update)
  before_filter :change_keys!, only: %i(create update)

  def index
    render_success(index_response)
  end

  def show
    render_success(show_response)
  end

  def create
    @association = @user.associations.create(create_attributes)
    if @association.errors.empty?
      render_success(show_response)
    else
      render_failure({reason: @association.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    if @association.update_attributes(permitted_params.association)
      render_success(update_response)
    else
      if @association.errors["associate.phone_numbers"].any?
        if @association.try(:association_type).try(:hcp?)
          render_failure({reason: "Care Team Member's phone number is invalid"}, 422)
        elsif @association.try(:asscoiation_type).try(:family?)
          render_failure({reason: "Family Member's phone number is invalid"}, 422)
        else
          render_failure({reason: 'Phone number is invalid'}, 422)
        end
      else
        render_failure({reason: @association.errors.full_messages.to_sentence}, 422)
      end
    end
  end

  def destroy
    @association.actor_id = current_user.id
    destroy_resource @association
  end

  def invite
    @association.invite!
    render_success(show_response(@association.pair))
  end

  private

  def load_associations!
    @associations = if params[:state] == 'pending'
                      @user.associations.pending.includes(:permission, :associate)
                    else
                      @user.associations.enabled.includes(:permission, :associate)
                    end
  end

  def load_association!
    @association = @user.associations.find(params[:id])
    authorize! :manage, @association
  end

  def verify_associate!
    if @associate = User.find_by_id(params[:association][:associate_id])
      raise CanCan::AccessDenied if @associate.owner_id != current_user.id || replacement_association
    end
  end

  def replacement_association
    Association.where(user_id: @associate.owner_id, associate_id: @associate.id).first.try(:replacement)
  end

  def verify_creator_permission!
    if @associate
      raise CanCan::AccessDenied if (current_user != @user) && (current_user != @associate) && (current_user != @associate.owner)
    end
  end

  def set_creator!
    params.require(:association)[:creator_id] = current_user.id
  end

  def set_owner!
    if params.require(:association)[:associate]
      params.require(:association)[:associate][:owner_id] ||= @user.id
    end
  end

  def convert_parameters!
    if associate_npi_number
      provider = find_or_create_provider_by_npi_number
      params[:association].except!(:associate)
      params[:association][:associate_id] = provider.id
    end
  end

  def associate_npi_number
    params.require(:association).try(:[], :associate).try(:[], :npi_number)
  end

  def find_or_create_provider_by_npi_number
    if provider = User.find_by_npi_number(associate_npi_number)
      provider
    else
      User.create!(provider_from_search.deep_merge(self_owner: true))
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
    result[:address] = [result[:address]]
    result.change_key!(:address, :addresses_attributes)
    PermittedParams.new(ActionController::Parameters.new(user: result), current_user).user
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  def unset_android_id_zero!
    params[:association][:associate][:id] = nil if params.require(:association).try(:[], :associate).try(:[], :id).try(:zero?) # TODO - disable sending fake id from client
  end

  def change_keys!
    params[:association].try(:[], :associate).try(:change_key!, :address, :address_attributes)
    params[:association].try(:change_key!, :associate, :associate_attributes)
  end

  def create_attributes
    permitted_params.association.tap do |attributes|
      attributes[:association_type_id] ||= AssociationType.family_default_id
    end
  end

  def index_response
    {
      associations: @associations.serializer(serializer_options),
      permissions: @associations.map(&:permission).serializer
    }
  end

  def show_response(association=nil)
    association ||= @association
    {
      association: association.serializer(serializer_options),
      permissions: [association.permission].serializer.as_json
    }
  end

  def update_response
    show_response.tap do |hash|
      unless @association.association_type.try(:hcp?)
        hash.merge!(users: [@association.user.serializer, @association.associate.serializer])
      end

      add_updated_association(hash, @association.pair, :inverse) if @association.pair
      add_updated_association(hash, @association.parent, :parent) if @association.parent
    end
  end

  def add_updated_association(hash, association, key)
    hash.merge!("#{key}_association".to_sym => association.serializer)
    hash[:permissions] << association.permission.serializer
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(scope: current_user)
      options.merge!(include_nested_information: true) if current_user.care_provider?
    end
  end
end
