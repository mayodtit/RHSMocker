class Api::V1::CustomCardsController < Api::V1::ABaseController
  before_filter :load_custom_card!, only: [:show, :update]

  def index
    index_resource CustomCard.all.serializer
  end

  def show
    show_resource @custom_card.serializer(preview: true, raw_preview: true)
  end

  def create
    create_resource CustomCard, custom_card_params
  end

  def update
    update_resource @custom_card, custom_card_params, :custom_card, {preview: true, raw_preview: true}
  end

  private

  def load_custom_card!
    @custom_card = CustomCard.find params[:id]
  end

  def custom_card_params
    params.require(:custom_card).permit(:title, :raw_preview)
  end
end
