class Api::V1::CardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_card!, only: [:show, :update]

  def inbox
    index_resource @user.cards.inbox.active_model_serializer_instance(preview: true)
  end

  def timeline
    index_resource @user.cards.timeline.active_model_serializer_instance
  end

  def show
    show_resource @card.active_model_serializer_instance(body: true)
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
    if @card.saved? || @card.dismissed?
      params[:card].delete(:state_changed_at) unless [:saved, :dismissed].include?(params[:card][:state_event])
    end
    params[:card].delete(:state_event) if params[:card].try(:[], :state_event).try(:to_sym) == :read # TODO - allow the client to send us read without crashing, for now
    params[:card]
  end
end
