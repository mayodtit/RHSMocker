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
    attributes = appointment_attributes
    attributes[:creator_id] = current_user.id

    @appointment = Appointment.create(attributes)

    if @appointment.errors.empty?
      render_success(appointment: @appointment.serializer)
    else
      render_failure({reason: @appointment.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    update_params = appointment_attributes
    update_params[:actor_id] = current_user.id

    if @appointment.update_attributes(update_params)
      render_success(appointment: @appointment.serializer)
    else
      render_failure({reason: @appointment.errors.full_messages.to_sentence}, 422)
    end
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
    params.require(:appointment).permit(:user_id, :provider_id, :scheduled_at)
  end
end
