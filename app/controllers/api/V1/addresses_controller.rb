class Api::V1::AddressesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_addresses!
  before_filter :load_address!, only: %i(show update destroy)

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
    @address = @addresses.find(params[:id])
  end
end
