class Api::V1::CustomCardsController < Api::V1::ABaseController
  before_filter :load_custom_card!, only: [:show, :update]

  def index
    index_resource CustomCard.all.serializer
  end

  def show
    show_resource @custom_card.serializer(preview: true)
  end

  def create
    create_resource CustomCard, params[:custom_card]
  end

  def update
    update_resource @custom_card, params[:custom_card]
  end

  private

  def load_custom_card!
    @custom_card = CustomCard.find params[:id]
  end
end
