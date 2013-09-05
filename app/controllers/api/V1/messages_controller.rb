class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!, :except => [:show, :mark_read, :dismiss, :save]
  before_filter :load_message!, :only => :show

  def index
    index_resource(messages_with_message_statuses)
  end

  def show
    # TODO - move cardview rendering to CardsController
    if params[:q] == 'cardview'
      html = render_to_string(:action => "cardview", :formats => :html, :locals => {:first_paragraph => @message.previewText})
    else
      html = render_to_string(:action => "full", :formats => :html)
    end
    show_resource(@message.as_json.merge(:body => html, :encounter_id => @message.consult_id))
  end

  def create
    create_resource(@consult.messages, create_params)
  end

  def mark_read
    render_success
  end

  def dismiss
    mark_message_statuses(:dismissed)
    render_success
  end

  def save
    mark_message_statuses(:read)
    render_success
  end

  private

  def load_consult!
    @consult = Consult.find(params[:consult_id] || params[:encounter_id])
    authorize! :manage, @consult
  end

  def load_message!
    @message = Message.find(params[:id])
    authorize! :manage, @message.consult
  end

  def create_params
    (params[:message] || {}).merge!(:user_id => @user.id)
  end

  def mark_message_statuses(status)
    params[:message].each do |message_params|
      message = Message.find(message_params[:id])
      authorize! :manage, message.consult
      MessageStatus.find_by_user_id_and_message_id(@user.id, message.id).update_attributes(:status => status)
    end
  end

  def messages_with_message_statuses
    options = Message::BASE_OPTIONS.merge(:only => :status) do |k, v1, v2|
      v1 << v2
    end
    @consult.messages.with_message_statuses_for(current_user).as_json(options)
  end
end
