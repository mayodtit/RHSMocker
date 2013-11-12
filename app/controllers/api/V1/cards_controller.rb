class Api::V1::CardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_card!, only: [:show, :update]

  def inbox
    index_resource @user.cards.inbox.active_model_serializer_instance(preview: true, card_actions: true)
  end

  def timeline
    index_resource @user.cards.timeline.active_model_serializer_instance
  end

  def show
    show_resource @card.active_model_serializer_instance(body: true, full_actions: true)
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
