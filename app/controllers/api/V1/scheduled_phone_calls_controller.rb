class Api::V1::ScheduledPhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_scheduled_phone_calls!
  before_filter :load_scheduled_phone_call!, only: [:show, :update, :destroy]

  def index
    index_resource @scheduled_phone_calls.serializer
  end

  def show
    show_resource @scheduled_phone_call.serializer
  end

  def create
    create_resource ScheduledPhoneCall, scheduled_phone_call_attributes
  end

  def update
    update_resource @scheduled_phone_call, scheduled_phone_call_attributes
  end

  def destroy
    destroy_resource @scheduled_phone_call
  end

  private

  def load_scheduled_phone_calls!
    authorize! :index, ScheduledPhoneCall
    @scheduled_phone_calls = ScheduledPhoneCall.all
  end

  def load_scheduled_phone_call!
    @scheduled_phone_call = ScheduledPhoneCall.find(params[:id])
    authorize! :manage, @scheduled_phone_call
  end

  def scheduled_phone_call_attributes
    params.require(:scheduled_phone_call).tap do |attributes|
      attributes[:user_id] = @user.id unless (@scheduled_phone_call.try(:user_id) || attributes[:user_id])
    end.permit(:scheduled_at, :user_id, :owner_id, :state_event)
  end
end
