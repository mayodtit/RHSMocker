class Api::V1::AddressesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_addresses!
  before_filter :load_address!, only: %i(show update destroy)
  before_filter :convert_attributes, only: :update

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

  private

  def load_addresses!
    @addresses = @user.addresses
  end

  def load_address!
    @address = if params[:id] == "office"
                 @addresses.find_by_name!("office")
               else
                 @addresses.find(params[:id])
               end
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
end
