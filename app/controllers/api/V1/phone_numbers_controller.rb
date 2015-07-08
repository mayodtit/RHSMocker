class Api::V1::PhoneNumbersController < Api::V1::ABaseController
  ## PhoneNumbers are a polymorphic relation, but currently only used by User, Address
  ## Currently only routed for User, so desperately trying to YAGNI any clever multi-user logic

  before_filter :load_owner!
  before_filter :load_phone_numbers!
  before_filter :load_phone_number!, only: %i(show update destroy)

  def index
    index_resource @phone_numbers.serializer
  end

  def create
    create_resource @phone_numbers, permitted_params.phone_number
  end

  def show
    show_resource @phone_number.serializer
  end

  def update
    update_resource @phone_number, permitted_params.phone_number
  end

  def destroy
    destroy_resource @phone_number
  end

  private

  def load_owner!
    puts "PhoneNumbersController#load_owner! - params: #{params}"
    if params[:user_id]
      puts "Looking up User ID: #{params[:user_id]}"
      @owner = User.find(params[:user_id])
    end
    puts "PHONE NUMBERS: #{@owner.phone_numbers}"
    authorize! :manage, @owner
  end

  def load_phone_numbers!
    @phone_numbers = @owner.phone_numbers
  end

  def load_phone_number!
    @phone_number = @phone_numbers.find(params[:id])
    authorize! :manage, @phone_number
  end
end
