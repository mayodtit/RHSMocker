class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    authorize! :index, Message
    index_resource (unread_messages + empty_consults).serializer
  end

  private

  def unread_messages
    Message.where(phone_call_id: nil, scheduled_phone_call_id: nil, unread_by_cp: true).group('consult_id')
  end

  def empty_consults
    Consult.joins('LEFT JOIN messages ON messages.consult_id = consults.id').select('consults.*').group('consults.id').having('COUNT(messages.consult_id) = 0')
  end
end