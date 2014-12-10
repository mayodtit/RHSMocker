class Api::V1::PhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!, :only => [:index, :show, :create, :update, :hang_up, :transfer, :merge, :outbound]
  before_filter :load_consult!, only: :create
  before_filter :load_phone_call!, :except => [:index, :create, :connect, :status, :connect_nurse, :outbound]
  before_filter :convert_parameters!, only: :create
  skip_before_filter :authentication_check, :except => [:index, :show, :create, :update, :hang_up, :transfer, :merge, :outbound]

  layout false, except: [:index, :show, :create, :update]
  # http_basic_authenticate_with name: "twilio", password: "secret", except: :index

  def index
    authorize! :read, PhoneCall

    authorized_phone_calls = []
    phone_calls.where(params.permit(:state))
               .includes(:to_role, :user, consult: [:initiator, :subject])
               .order('created_at ASC')
               .each do |p|
      authorized_phone_calls.push(p) if can? :read, p
    end

    index_resource authorized_phone_calls.serializer
  end

  def show
    authorize! :read, @phone_call
    show_resource @phone_call.serializer
  end

  def create
    create_resource @consult.phone_calls, permitted_params.phone_call
  end

  def outbound
    authorize! :create, PhoneCall

    phone_call_params = params.require(:phone_call).permit(:user_id,
                                                           :destination_phone_number)
    phone_call_params[:outbound] = true
    phone_call_params[:creator_id] = current_user.id
    phone_call_params[:origin_phone_number] = current_user.work_phone_number

    create_resource PhoneCall, phone_call_params
  end

  def update
    authorize! :update, @phone_call

    update_params = params.require(:phone_call).permit(:state_event, :merged_into_phone_call_id, :user_id)

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
    @phas_off_duty = !Role.find_by_name!(:pha).on_call?
    @phone_call = PhoneCall.resolve params['From'], params['CallSid']
    @select_url = URL_HELPERS.triage_select_api_v1_phone_call_url(@phone_call)
    @menu_url = URL_HELPERS.triage_menu_api_v1_phone_call_url(@phone_call)
    @send_to_queue = queue_enabled?
    render formats: [:xml]
  end

  def connect_nurse
    @phone_call = PhoneCall.resolve params['From'], params['CallSid'], Role.nurse
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
        @phone_call.transfer! Member.robot
        @phone_call.miss! 'after_hours'
        @nurseline_phone_call = @phone_call.transferred_to_phone_call
        render action: :transfer_nurse, formats: [:xml]
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
    @phone_call.transfer! current_user
    show_resource @phone_call.serializer
  end

  def merge
    authorize! :merge, @phone_call
    user_id = params.require(:caller_id)
    unresolved_phone_call = PhoneCall.where(state: :unresolved, user_id: user_id).last
    if unresolved_phone_call && ((unresolved_phone_call.created_at - @phone_call.created_at) / 1.minute).to_i.abs <= 10
      unresolved_phone_call.update_attributes state_event: :merge, merged_into_phone_call: @phone_call

      unless unresolved_phone_call.valid?
        render_failure({:reason => unresolved_phone_call.full_messages.to_sentence}, 422)
        return
      end

      show_resource @phone_call.reload.serializer
    else
      update_resource @phone_call, user_id: user_id
    end
  end

  private

  def phone_calls
    PhoneCall
  end

  def disconnected_call_status?
    params['CallStatus'] != 'ringing' && params['CallStatus'] != 'in-progress' && params['CallStatus'] != 'queued'
  end

  def load_phone_call!
    @phone_call = PhoneCall.find params[:id]
  end

  def queue_enabled?
    Metadata.find_by_mkey('enable_pha_phone_queue').try(:mvalue) == 'true'
  end

  def load_consult!
    @consult = if params[:consult_id] == 'current'
                 @user.master_consult
               else
                 Consult.find(params[:consult_id])
               end
    authorize! :manage, @consult
  end

  def convert_parameters!
    params.require(:phone_call).tap do |attributes|
      attributes[:user_id] ||= @user.id
      attributes[:to_role_id] ||= Role.find_by_name!(attributes[:to_role]).id if attributes[:to_role]
    end
  end
end
