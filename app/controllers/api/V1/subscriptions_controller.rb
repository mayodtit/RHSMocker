class Api::V1::SubscriptionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_user!

  def index
    @subscriptions = subscription_scope.all
    render_success({subscriptions: @subscriptions})
  end

  def show
    @subscription = subscription_scope.find(params[:id])
    render_success({subscription: @subscription})
  end

  def create
    @subscription = subscription_scope.create(params[:subscription])
    if @subscription.errors.empty?
      render_success({subscription: @subscription})
    else
      render_failure({reason: @subscription.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    @subscription = subscription_scope.find(params[:id])
    if @subscription.update_attributes(params[:subscription])
      render_success({subscription: @subscription})
    else
      render_failure({reason: @subscription.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    @subscription = subscription_scope.find(params[:id])
    if @subscription.destroy
      render_success
    else
      render_failure({reason: @subscription.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def subscription_scope
    @user.try(:subscriptions) || Subscription
  end
end
