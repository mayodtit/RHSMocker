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
    show_resource @user.serializer(serializer_options)
  end

  private

  def create_user
    @provider = search_service.find(params)
    @user_from_provider = User.create!(user_attributes)
    @user_from_provider.addresses.create!(address_attributes)
    @user_from_provider
  end

  def user_attributes
    @provider.except(:address, :state, :healthcare_taxonomy_code, :taxonomy_classification)
  end

  def address_attributes
    @provider[:address].except(:country_code, :phone, :fax)
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
    @user = User.find_by_npi_number(params[:npi_number]) || create_user
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
