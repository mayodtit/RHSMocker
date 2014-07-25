class Api::V1::ScheduledCommunicationsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_scheduled_communications!
  before_filter :load_scheduled_communication!, only: %i(show update destroy)

  def index
    index_resource @scheduled_communications.serializer
  end

  def show
    show_resource @scheduled_communication.serializer
  end

  def update
    update_resource @scheduled_communication, permitted_params.scheduled_communication
  end

  def destroy
    destroy_resource @scheduled_communication
  end

  private

  def load_user!
    @user = Member.find(params[:user_id])
    authorize! :manage, @user
  end

  def load_scheduled_communications!
    authorize! :manage, ScheduledCommunication
    @scheduled_communications = @user.inbound_scheduled_communications
  end

  def load_scheduled_communication!
    @scheduled_communication = @scheduled_communications.find(params[:id])
    authorize! :manage, @scheduled_communication
  end
end
