class Api::V1::ScheduledPhoneCallsController < Api::V1::ABaseController
  before_filter :load_scheduled_phone_call!, only: [:show, :update, :state_event, :destroy]

  def index
    results = ScheduledPhoneCall.where params.permit(:state, :user_id, :owner_id)

    if params[:scheduled_after]
      results = results.where 'scheduled_at > ?', params[:scheduled_after]
    end

    index_resource filter_authorized_scheduled_phone_calls(results).serializer
  end

  def show
    authorize! :read, @scheduled_phone_call
    show_resource @scheduled_phone_call.serializer
  end

  def create
    authorize! :create, ScheduledPhoneCall
    create_params = create_or_update_params
    create_resource ScheduledPhoneCall, create_params
  end

  def update
    authorize! :update, @scheduled_phone_call
    update_params = create_or_update_params
    update_resource @scheduled_phone_call, update_params
  end

  # SECURITY NOTE: A member can schedule a phone call for another member through
  # the API.
  def state_event
    authorize! :update, @scheduled_phone_call
    state_event = params[:state_event]
    state_event_f = state_event.to_sym

    if @scheduled_phone_call.respond_to? state_event_f
      if params[:scheduled_phone_call]
        subject_id = params[:scheduled_phone_call][:owner_id] || params[:scheduled_phone_call][:user_id]
        subject = nil
        subject = Member.find(subject_id) if subject_id
      end

      @scheduled_phone_call.send(state_event_f, current_user, subject)
    else
      render_failure({reason: 'Invalid state event'}, 422)
      return
    end

    if @scheduled_phone_call.valid?
      show_resource @scheduled_phone_call.serializer
    else
      render_failure({reason: @scheduled_phone_call.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    authorize! :delete, @scheduled_phone_call
    destroy_resource @scheduled_phone_call
  end

  private

  # NOTE: This is super inefficient, but unfortunately our ability file is not
  # optimized for queries. See https://github.com/ryanb/cancan/wiki/Defining-Abilities
  # on how to optimize
  def filter_authorized_scheduled_phone_calls(scheduled_phone_calls)
    authorized_phone_calls = []
    scheduled_phone_calls.find_each do |p|
      authorized_phone_calls.push(p) if can? :read, p
    end
    authorized_phone_calls
  end

  def create_or_update_params
    permitted_params = params.require(:scheduled_phone_call).permit(:owner_id, :scheduled_at)

    if permitted_params[:owner_id]
      permitted_params[:state] = 'assigned'
      permitted_params[:assignor_id] = current_user.id
      permitted_params[:assigned_at] = Time.now
    end

    permitted_params
  end

  def load_scheduled_phone_call!
    @scheduled_phone_call = ScheduledPhoneCall.find(params[:id])
  end
end
