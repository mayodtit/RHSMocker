class Api::V1::PhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_phone_call!, :only => [:show, :update, :destroy]

  def index
    index_resource(@consult.phone_calls)
  end

  def show
    show_resource(@phone_call)
  end

  def create
    create_resource(PhoneCall, phone_call_params)
  end

  private

  def load_consult!
    @consult = Consult.find(params[:consult_id])
    authorize! :manage, @consult
  end

  def load_phone_call!
    @phone_call = @consult.phone_calls.find(params[:id])
  end

  def phone_call_params
    (params[:phone_call] || {}).merge!(:user => @user, :message_attributes => message_params)
  end

  def message_params
    {
      user: @user,
      consult: @consult,
      text: 'Phone call'
    }
  end
end
