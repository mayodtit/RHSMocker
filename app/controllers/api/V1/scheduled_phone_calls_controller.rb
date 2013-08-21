class Api::V1::ScheduledPhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_scheduled_phone_call!, :only => [:show, :update, :destroy]

  def index
    index_resource(@consult.scheduled_phone_calls)
  end

  def show
    show_resource(@scheduled_phone_call)
  end

  def create
    create_resource(ScheduledPhoneCall, scheduled_phone_call_params)
  end

  def update
    update_resource(@scheduled_phone_call, params[:scheduled_phone_call])
  end

  def destroy
    destroy_resource(@scheduled_phone_call)
  end

  private

  def load_consult!
    @consult = Consult.find(params[:consult_id])
    authorize! :manage, @consult
  end

  def load_scheduled_phone_call!
    @scheduled_phone_call = @consult.scheduled_phone_calls.find(params[:id])
  end

  def scheduled_phone_call_params
    (params[:scheduled_phone_call] || {}).merge!(:user => @user,
                                                 :message_attributes => ScheduledPhoneCall.message_params(@user, @consult))
  end
end
