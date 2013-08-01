class Api::V1::MessagesController < Api::V1::ABaseController
  before_filter :load_encounter!
  before_filter :load_message!, :only => :show

  def index
    index_resource(@encounter.messages)
  end

  def show
    show_resource(@message)
  end

  def create
    create_resource(@encounter.messages, params[:message])
  end

  private

  def load_encounter!
    @encounter = Encounter.find(params[:encounter_id])
    authorize! :manage, @encounter
  end

  def load_message!
    @message = @encounter.messages.find(params[:id])
  end
end
