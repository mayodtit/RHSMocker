class Api::V1::SubscriptionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_subscription!, :only => [:show, :update, :destroy]

  def index
    index_resource(@user.subscriptions.active_model_serializer_instance)
  end

  def show
    show_resource(@subscription.active_model_serializer_instance)
  end

  def create
    create_resource(@user.subscriptions, params[:subscription])
  end

  def update
    update_resource(@subscription, params[:subscription])
  end

  def destroy
    destroy_resource(@subscription)
  end

  private

  def load_subscription!
    @subscription = @user.subscriptions.find(params[:id])
    authorize! :manage, @subscription
  end
end
