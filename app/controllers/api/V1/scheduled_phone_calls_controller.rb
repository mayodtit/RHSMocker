class Api::V1::ScheduledPhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_scheduled_phone_calls!
  before_filter :load_scheduled_phone_call!, only: [:show, :update, :destroy]

  def index
    index_resource @scheduled_phone_calls
  end

  def show
    show_resource @scheduled_phone_call
  end

  def create
    create_resource @scheduled_phone_calls, scheduled_phone_call_attributes
  end

  def update
    update_resource @scheduled_phone_call, scheduled_phone_call_attributes
  end

  def destroy
    destroy_resource @scheduled_phone_call
  end

  private

  def load_scheduled_phone_calls!
    @scheduled_phone_calls = ScheduledPhoneCall.scoped
    authorize! :index, ScheduledPhoneCall
  end

  def load_scheduled_phone_call!
    @scheduled_phone_call = @scheduled_phone_calls.find(params[:id])
    authorize! :manage, @scheduled_phone_call
  end

  def scheduled_phone_call_attributes
    params.require(:scheduled_phone_call).tap do |attributes|
      attributes[:user_id] = @user.id unless (@scheduled_phone_call.try(:user_id) || attributes[:user_id])
    end.permit(:scheduled_at, :user_id)
  end
end
