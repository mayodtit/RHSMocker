class Api::V1::AddressesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_addresses!
  before_filter :load_address!, only: %i(show update destroy)
  before_filter :convert_attributes, only: :update
  before_filter :load_office_address!, only: [:show_office_address, :update_office_address]

  def index
    index_resource @addresses.serializer
  end

  def show
    show_resource @address.serializer
  end

  def create
    create_resource @addresses, permitted_params.address
  end

  def update
    update_resource @address, permitted_params.address
  end

  def destroy
    destroy_resource @address
  end

  def show_office_address
    show_resource @office_address.serializer
  end

  def update_office_address
    update_resource @office_address, permitted_params.address
  end

  private

  def load_addresses!
    @addresses = @user.addresses
  end

  def load_address!
    @address = @addresses.find(params[:id])
  end

  # remove duplicate aliased attributes when present
  def convert_attributes
    address_params.delete(:address) if address_params[:line1]
    address_params.delete(:address2) if address_params[:line2]
    address_params.delete(:type) if address_params[:name]
  end

  def address_params
    params.require(:address)
  end

  def load_office_address!
    @office_address = @addresses.where(name: "Office").first
  end
end
