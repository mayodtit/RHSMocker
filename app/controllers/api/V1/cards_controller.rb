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
    create_resource @user.cards, card_params
  end

  def update
    update_resource @card, card_params
  end

  private

  def load_card!
    @card = @user.cards.find params[:id]
    authorize! :manage, @card
  end

  def card_params
    params[:card][:state_event] ||= params[:card].delete(:state) # don't let the client set the state explicitly
    params[:card]
  end
end
