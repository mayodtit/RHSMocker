class Api::V1::PhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!, :only => [:index, :show, :update]
  before_filter :load_phone_call!, :except => [:index, :connect, :status]
  skip_before_filter :authentication_check, :except => [:index, :show, :update]

  layout false, except: [:index, :show, :update]
  # http_basic_authenticate_with name: "twilio", password: "secret", except: :index

  def index
    authorize! :read, PhoneCall

    phone_calls = []
    PhoneCall.where(params.permit(:state)).order('created_at ASC').find_each do |p|
      phone_calls.push(p) if can? :read, p
    end

    index_resource phone_calls.as_json(
      include: {
        user: {
          only: [:first_name, :last_name, :email],
          methods: [:full_name]
        }
      }
    )
  end

  def show
    authorize! :read, @phone_call
    show_resource @phone_call.as_json(include: [:user, consult: {include: [:subject, :initiator]}])
  end

  def update
    authorize! :update, @phone_call

    update_params = params.require(:phone_call).permit(:state_event)

    if %w(claim end).include? update_params[:state_event]
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
    end

    if @phone_call.update_attributes update_params
      show_resource @phone_call.as_json(include: [:user, consult: {include: [:subject, :initiator]}])
    else
      render_failure({reason: @phone_call.errors.full_messages.to_sentence}, 422)
    end
  end

  def connect_origin
    @phone_call.dial_destination
    render formats: [:xml], handler: [:builder]
  end

  def connect_destination
    render formats: [:xml], handler: [:builder]
  end

  def connect
    render formats: [:xml], handler: [:builder]
  end

  def status_origin
    if params['CallStatus'] == 'completed'
    elsif params['CallStatus'] == 'failed'
    elsif params['CallStatus'] == 'busy'
    elsif params['CallStatus'] == 'no-answer'
    end

    head :ok, :content_type => 'text/html'
  end

  def status_destination
    if params['CallStatus'] == 'completed'
    elsif params['CallStatus'] == 'failed'
    elsif params['CallStatus'] == 'busy'
    elsif params['CallStatus'] == 'no-answer'
    end

    head :ok, :content_type => 'text/html'
  end

  def status
    head :ok, :content_type => 'text/html'
  end

  private

  def load_phone_call!
    @phone_call = PhoneCall.find params[:id]
  end
end
