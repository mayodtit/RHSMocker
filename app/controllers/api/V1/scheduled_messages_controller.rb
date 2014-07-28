class Api::V1::ScheduledMessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_scheduled_messages!
  before_filter :load_scheduled_message!, only: %i(show update destroy)
  before_filter :convert_parameters, only: :create

  def index
    index_resource @scheduled_messages.serializer
  end

  def show
    show_resource @scheduled_message.serializer
  end

  def create
    create_resource @scheduled_messages, permitted_params.scheduled_message
  end

  def update
    update_resource @scheduled_message, permitted_params.scheduled_message
  end

  def destroy
    destroy_resource @scheduled_message
  end

  private

  def load_user!
    if params[:consult_id]
      @user = Consult.find(params[:consult_id]).initiator
    else
      @user = Member.find(params[:user_id])
    end
    authorize! :manage, @user
  end

  def load_scheduled_messages!
    authorize! :manage, ScheduledMessage
    @scheduled_messages = @user.inbound_scheduled_messages
  end

  def load_scheduled_message!
    @scheduled_message = @scheduled_messages.find(params[:id])
    authorize! :manage, @scheduled_message
  end

  def convert_parameters
    params.require(:scheduled_message)[:sender_id] ||= current_user.id
  end
end
