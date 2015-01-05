class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_users!, only: :index

  def index
    render_success(consult: @consult.serializer,
                   messages: messages.serializer(shallow: true),
                   users: @users.serializer)
  end

  def create
    create_resource(@consult.messages, message_attributes)
  end

  private

  def messages
    if params[:page].nil?
      messages = @consult.messages
      messages = @consult.messages_and_notes if current_user.care_provider? && @consult.initiator != current_user
      messages = messages.where('created_at > ?', Time.parse(params[:last_message_date])) if params[:last_message_date].present?
    else
      messages = @consult.messages.order('created_at DESC').page params[:page]
      messages = @consult.messages_and_notes.order('created_at DESC').page params[:page] if current_user.care_provider? && @consult.initiator != current_user
      messages = @consult.messages.where('created_at > ?', Time.parse(params[:last_message_date])).order('created_at DESC').page params[:page] if params[:last_message_date].present?
    end
    messages.includes(:user)
  end

  def load_consult!
    @consult = if params[:consult_id] == 'current'
                 @user.master_consult
               else
                 Consult.find(params[:consult_id])
               end
    raise ActiveRecord::RecordNotFound unless @consult
    authorize! :manage, @consult
  end

  def load_users!
    @users = @consult.users.to_a
    @users = @users << @user.pha if @user.pha
    @users = @users.uniq
  end

  def message_attributes
    params.require(:message).permit(:text, :image, :content_id, :symptom_id, :condition_id, :note).tap do |attributes|
      attributes[:user] = current_user.impersonated_user || current_user
      attributes[:image] = decode_b64_image(attributes[:image]) if attributes[:image]
    end
  end
end
