class Api::V1::ConsultPhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_consult!
  before_filter :load_phone_call!, :only => [:show, :update, :destroy]

  def index
    index_resource(@consult.phone_calls, 'phone_calls')
  end

  def show
    show_resource(@phone_call, 'phone_call')
  end

  def create
    strong_params = params.permit(:phone_call => [:origin_phone_number, :destination_phone_number])
    create_resource(PhoneCall, phone_call_params(strong_params), 'phone_call')
  end

  private

  def load_consult!
    @consult = Consult.find(params[:consult_id])
    authorize! :manage, @consult
  end

  def load_phone_call!
    @phone_call = @consult.phone_calls.find(params[:id])
  end

  def phone_call_params(params)
    (params[:phone_call] || {}).merge!(:user => @user,
                                       :message_attributes => Message.phone_params(:phone_call, @user, @consult))
  end
end
