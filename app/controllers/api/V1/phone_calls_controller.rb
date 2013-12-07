class Api::V1::PhoneCallsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_phone_call!, :only => [:update, :show]

  def index
    authorize! :read, PhoneCall
    index_resource PhoneCall.where(params.permit(:state)).order('created_at ASC').as_json(
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

    state_event = params.require(:phone_call).require(:state_event)
    state_event_f = state_event.to_sym

    if @phone_call.respond_to? state_event_f
      @phone_call.send(state_event_f, current_user)
    else
      render_failure({reason: 'Invalid state event'}, 422)
      return
    end

    if @phone_call.valid?
      show_resource @phone_call.as_json(include: [:user, consult: {include: [:subject, :initiator]}])
    else
      render_failure({reason: @phone_call.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_phone_call!
    @phone_call = PhoneCall.find params[:id]
  end
end
