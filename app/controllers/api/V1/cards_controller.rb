class Api::V1::CardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_card!, only: [:show, :update]

  def index
    index_resource(merge_previews(@user.cards.not_dismissed))
  end

  def inbox
    index_resource(merge_previews(@user.cards.inbox))
  end

  def timeline
    index_resource(merge_previews(@user.cards.timeline))
  end

  def show
    show_resource(merge_body(@card))
  end

  def update
    update_resource(@card, card_params)
  end

  private

  def load_card!
    @card = @user.cards.find(params[:id])
    authorize! :manage, @card
  end

  def card_params
    if @card.saved? || @card.dismissed?
      params[:card].delete(:state_changed_at) unless [:saved, :dismissed].include?(params[:card][:state_event])
    end
    params[:card]
  end

  def merge_previews(cards)
    cards.map{|c| c.as_json.merge!(:preview => render_to_string(:action => :preview,
                                                                :formats => [:html],
                                                                :locals => {:card => c, :resource => c.resource}))}
  end

  def merge_body(card)
    card.as_json.merge!(:body => render_to_string(:action => :show,
                                                  :formats => [:html],
                                                  :locals => {:card => card}))
  end
end
