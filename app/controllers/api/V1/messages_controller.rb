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
    @message = @consult.messages.create(message_attributes)
    if @message.errors.empty?
      @message = Message.find(@message.id) # force reload of CarrierWave image url
      render_success(message: @message.serializer)
    else
      render_failure({reason: @message.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def messages
    base_messages_with_pagination.includes(:user).sort_by(&:id)
  end

  def base_messages_with_pagination
    if page_size && !care_portal?
      filter_excluded(before_message_id(base_messages.order('id DESC').page(page_number).per(page_size)))
    elsif params[:last_message_date]
      base_messages.where('created_at > ?', Time.parse(params[:last_message_date]))
    else
      base_messages
    end
  end

  def base_messages
    if current_user.care_provider? && @consult.initiator != current_user
      @consult.messages_and_notes
    else
      @consult.messages
    end
  end

  def filter_excluded(page)
    byebug
    filter_ids ||= params[:exclude].split(",")
    page.where('id not in (?)',(filter_ids.nil? ? [] : filter_ids))
  end

  def page_number
    @page_number ||= params[:page] || 1
  end

  def page_size
    @page_size ||= params[:per] || Metadata.default_page_size
  end

  def before_message_id(page)
    before_id ||= params[:before]
    page.where('id < (?)', before_id)
  end

  def care_portal?
    params[:care_portal].present?
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
