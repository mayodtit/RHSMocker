class Api::V1::ProvidersController < Api::V1::ABaseController
  before_filter :load_providers!, only: [:index, :search]
  before_filter :load_provider!, only: :show

  # deprecated - use #search instead
  def index
    index_resource @providers, name: :users
  end

  def search
    index_resource @providers, name: :providers
  end

  def show
    if @provider.is_a?(User)
      show_resource @provider.serializer(serializer_options)
    else
      user = User.create!(user_attributes)
      user.addresses.create!(address_attributes)
      show_resource user.serializer(serializer_options)
    end
  end

  private

  def user_attributes
    @provider.except(:address, :state, :healthcare_taxonomy_code, :taxonomy_classification)
  end

  def address_attributes
  {
    address: @provider[:address][:address],
    address2: @provider[:address][:address2],
    city: @provider[:address][:city],
    state: @provider[:address][:state],
    postal_code: @provider[:address][:postal_code]
  }
  end

  def load_providers!
    # remove whitespace from params
    [:first_name, :last_name].each { |k| params[k].strip! unless params[k].nil? }

    search_service.proximity(params)
    begin
      @providers = search_service.query(params)
    rescue => e
      render_failure({reason: e.message}, 502)
    end
  end

  def load_provider!
    @provider = User.find_by_npi_number(params[:npi_number]) || search_service.find(params)
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(include_nested_information: true, include_roles: true) if current_user.care_provider?
    end
  end
end
