class Api::V1::CardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_card!, only: [:show, :update]

  def inbox
    index_resource @user.cards.inbox.serializer(preview: true, scope: current_user)
  end

  def timeline
    index_resource @user.cards.timeline.serializer(scope: current_user)
  end

  def show
    show_resource @card.serializer(body: true, scope: current_user)
  end

  def create
    authorize! :create, Card
    create_resource @user.cards, create_params
  end

  def update
    update_resource @card, update_params
  end

  private

  def load_card!
    @card = @user.cards.find params[:id]
    authorize! :manage, @card
  end

  def create_params
    params.require(:card).permit(:resource_id,
                                 :resource_type,
                                 :priority,
                                 :sender_id).tap do |attributes|
      attributes[:sender_id] ||= current_user.id
    end
  end

  def update_params
    params[:card][:state_event] ||= params[:card].delete(:state) # don't let the client set the state explicitly
    params[:card]
  end
end
