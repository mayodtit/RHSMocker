class Api::V1::PhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!, :only => [:index, :show, :update, :hang_up, :transfer]
  before_filter :load_phone_call!, :except => [:index, :connect, :status, :connect_nurse]
  skip_before_filter :authentication_check, :except => [:index, :show, :update, :hang_up, :transfer]

  layout false, except: [:index, :show, :update]
  # http_basic_authenticate_with name: "twilio", password: "secret", except: :index

  def index
    authorize! :read, PhoneCall

    phone_calls = []
    PhoneCall.where(params.permit(:state))
             .includes(:to_role, :user, consult: [:initiator, :subject])
             .order('created_at ASC')
             .each do |p|
      phone_calls.push(p) if can? :read, p
    end

    index_resource phone_calls.serializer
  end

  def show
    authorize! :read, @phone_call
    show_resource @phone_call.serializer
  end

  def update
    authorize! :update, @phone_call

    update_params = params.require(:phone_call).permit(:state_event)

    if %w(dial claim end).include? update_params[:state_event]
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
    end

    update_resource @phone_call, update_params
  end

  def connect_origin
    @phone_call.update_attributes!(origin_status: PhoneCall::CONNECTED_STATUS)
    @phone_call.dial_destination if @phone_call.dialing?
    render formats: [:xml]
  end

  def connect_destination
    @phone_call.update_attributes!(destination_status: PhoneCall::CONNECTED_STATUS)
    @phone_call.dial_origin if @phone_call.dialing?
    render formats: [:xml]
  end

  def connect
    @phas_off_duty = !PhoneCall::accepting_calls_to_pha?
    @phone_call = PhoneCall.resolve params['From'], params['CallSid']
    @select_url = URL_HELPERS.triage_select_api_v1_phone_call_url(@phone_call)
    @menu_url = URL_HELPERS.triage_menu_api_v1_phone_call_url(@phone_call)
    @send_to_queue = queue_enabled?
    render formats: [:xml]
  end

  def triage_menu
    @menu_url = URL_HELPERS.triage_menu_api_v1_phone_call_url(@phone_call)
    @select_url = URL_HELPERS.triage_select_api_v1_phone_call_url(@phone_call)
    render formats: [:xml]
  end

  # TODO: Pass in why call was missed
  def triage_select
    case params['Digits']
      when '*'
        @phone_call.miss! 'after_hours'
        render action: :goodbye, formats: [:xml]
        return
      when '1'
        @phone_call.transfer!
        @phone_call.miss! 'after_hours'
        @nurseline_phone_call = @phone_call.transferred_to_phone_call
        render action: :connect_nurse, formats: [:xml]
        return
    end

    redirect_to action: :triage_menu, id: @phone_call.id
  end

  def status_origin
    attrs = { origin_status: params['CallStatus'] }
    attrs[:state_event] = 'disconnect' if disconnected_call_status?
    @phone_call.update_attributes! attrs

    head :ok, :content_type => 'text/html'
  end

  def status_destination
    attrs = { destination_status: params['CallStatus'] }
    attrs[:state_event] = 'disconnect' if disconnected_call_status?
    @phone_call.update_attributes! attrs

    head :ok, :content_type => 'text/html'
  end

  def status
    if phone_call = PhoneCall.find_by_origin_twilio_sid(params['CallSid'])
      attrs = { origin_status: params['CallStatus'] }
      attrs[:state_event] = 'disconnect' if disconnected_call_status?

      phone_call.update_attributes! attrs
    end

    head :ok, :content_type => 'text/html'
  end

  def hang_up
    authorize! :hang_up, @phone_call
    @phone_call.hang_up
    show_resource @phone_call.serializer
  end

  def transfer
    authorize! :transfer, @phone_call
    @phone_call.transfer!
    show_resource @phone_call.serializer
  end

  private

  def disconnected_call_status?
    params['CallStatus'] != 'ringing' && params['CallStatus'] != 'in-progress' && params['CallStatus'] != 'queued'
  end

  def load_phone_call!
    @phone_call = PhoneCall.find params[:id]
  end

  def queue_enabled?
    Metadata.find_by_mkey('enable_pha_phone_queue').try(:mvalue) == 'true'
  end
end
