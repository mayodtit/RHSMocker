class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    authorize! :index, Message
    index_resource unread_messages.serializer
  end

  private

  def unread_messages
    Message.where phone_call_id: nil, scheduled_phone_call_id: nil, unread_by_cp: true
  end
end