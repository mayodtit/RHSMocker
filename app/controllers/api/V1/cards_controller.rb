class Api::V1::CardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_card!, only: [:show, :update]

  def index
    index_resource(merge_abstracts(@user.cards))
  end

  def inbox
    index_resource(merge_abstracts(@user.cards.inbox))
  end

  def timeline
    index_resource(merge_abstracts(@user.cards.timeline))
  end

  def show
    show_resource(@card)
  end

  def update
    update_resource(@card, params[:card])
  end

  private

  def load_card!
    @card = @user.cards.find(params[:id])
    authorize! :manage, @card
  end

  def merge_abstracts(cards)
    cards.map{|c| c.as_json.merge!(:abstract => render_to_string(:action => :abstract, :locals => {:card => c}))}
  end
end
