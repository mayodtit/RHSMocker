class Api::V1::CardsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_card!, only: [:show, :update]

  def index
    case params[:type]
    when 'carousel'
      index_resource(@user.cards.inbox)
    when 'timeline'
      index_resource(@user.cards.timeline)
    else
      index_resource(@user.cards.inbox_or_timeline)
    end
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
end
