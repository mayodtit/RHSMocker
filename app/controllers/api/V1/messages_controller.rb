class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_encounter!, :except => [:show, :mark_read, :dismiss, :save]
  before_filter :load_message!, :only => :show

  def index
    index_resource(@encounter.messages)
  end

  def show
    # TODO - move cardview rendering to CardsController
    if params[:q] == 'cardview'
      html = render_to_string(:action => "cardview", :formats => :html, :locals => {:first_paragraph => @message.previewText})
    else
      html = render_to_string(:action => "full", :formats => :html)
    end
    show_resource(@message.as_json.merge(:body => html))
  end

  def create
    create_resource(@encounter.messages, create_params)
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

  def load_encounter!
    @encounter = Encounter.find(params[:encounter_id])
    authorize! :manage, @encounter
  end

  def load_message!
    @message = Message.find(params[:id])
    authorize! :manage, @message.encounter
  end

  def create_params
    (params[:message] || {}).merge!(:user_id => @user.id)
  end

  def mark_message_statuses(status)
    params[:message].each do |message_params|
      message = Message.find(message_params[:id])
      authorize! :manage, message.encounter
      MessageStatus.find_by_user_id_and_message_id(@user.id, message.id).update_attributes(:status => status)
    end
  end
end
