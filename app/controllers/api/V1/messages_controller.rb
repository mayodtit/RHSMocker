class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_users!, only: :index

  def index
    render_success(consult: @consult.serializer,
                   messages: messages.serializer(shallow: true),
                   users: @users.serializer,
                   total_count: @total_count_per_user,
                   messaging_tutorial: messaging_tutorial)
  end

  def create
    @message = @consult.messages.create(message_attributes)
    if @message.errors.empty?
      @message = Message.find(@message.id) # force reload of CarrierWave image url
      render_success(message: @message.serializer, messages: messages.serializer, entry: @message.entry.serializer)
    else
      render_failure({reason: @message.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def messages
    base_messages_with_pagination.includes(:user).exclude(params[:exclude]).sort_by(&:id)
  end

  def base_messages_with_pagination
    if show_all?
      base_messages
    else
      base_messages_scopes.page(page_number).per(page_size)
    end
  end

  def base_messages_scopes
    if params[:last_message_date]
      base_messages.where('created_at > ?', Time.parse(params[:last_message_date]))
    else
      base_messages.order('id DESC').before(params[:before]).after(params[:after])
    end
  end

  def base_messages
    if current_user.care_provider? && @consult.initiator != current_user
      @total_count_per_user = @consult.messages_and_notes.count
      @consult.messages_and_notes
    else
      @total_count_per_user = @consult.messages.count
      @consult.messages
    end
  end

  def page_number
    @page_number ||= params[:page] || 1
  end

  def page_size
    @page_size ||= params[:per] || Metadata.default_page_size
  end

  def show_all?
    params[:show_all].present?
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
    permitted_params.message.tap do |attributes|
      attributes[:pubsub_client_id] = params[:pubsub_client_id]
      attributes[:user] = current_user.impersonated_user || current_user
      attributes[:image] = decode_b64_image(attributes[:image]) if attributes[:image]
    end
  end

  def messaging_tutorial
    if @consult.initiator.messages.any?
      nil
    else
      {
        text: "Tell us how we can help you by sending a message to a Personal Health Assistant."
      }
    end
  end
end
