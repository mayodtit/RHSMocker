class Api::V1::AppointmentsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_appointments!
  before_filter :load_appointment!, only: %i(show update destroy)

  def index
    index_resource @appointments.serializer
  end

  def show
    show_resource @appointment.serializer
  end

  def create
    create_resource @appointments, create_params
  end

  def update
    update_resource @appointment, update_params
  end

  def destroy
    destroy_resource @appointment
  end

  private

  def load_appointments!
    @appointments = @user.appointments
  end

  def load_appointment!
    @appointment = @appointments.find(params[:id])
  end

  def appointment_attributes
    params.require(:appointment).permit(:user_id, :provider_id, :scheduled_at, :reason_for_visit, :special_instructions)
  end

  def create_params
    appointment_attributes.tap do |attrs|
      attrs[:creator] = current_user
      attrs[:address_attributes] = params[:appointment][:address].except('id', 'user_id', 'created_at', 'updated_at', 'name', 'phone_numbers')
      attrs[:phone_number_attributes] = phone_number_params
    end
  end

  def phone_number_params
    {
      number: params[:appointment][:phone_number],
      primary: false,
      type: "Work"
    }
  end

  def update_params
    appointment_attributes.tap do |attrs|
      attrs[:actor_id] = current_user.id
    end
  end
end
