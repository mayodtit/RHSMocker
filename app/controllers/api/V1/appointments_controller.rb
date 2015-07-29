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
    create_resource @appointments, appointment_attributes
  end

  def update
    update_resource @appointment, appointment_attributes
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
    params.require(:appointment).permit(:user_id, :provider_id, :scheduled_at, :reason, :actor_id, :creator_id)
  end
end
