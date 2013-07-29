class Api::V1::ItemsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_item!, only: [:show, :update]

  def index
    case params[:type]
    when 'carousel'
      index_resource(@user.items.inbox)
    when 'timeline'
      index_resource(@user.items.timeline)
    else
      index_resource(@user.items.inbox_or_timeline)
    end
  end

  def show
    show_resource(@item)
  end

  def update
    update_resource(@item, params[:item])
  end

  private

  def load_item!
    @item = @user.items.find(params[:id])
    authorize! :manage, @item
  end
end
