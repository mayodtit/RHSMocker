class Api::V1::ScheduledPhoneCallsController < Api::V1::ABaseController
  before_filter :load_available_scheduled_phone_calls!, only: [:available_times]
  before_filter :load_scheduled_phone_call!, only: [:show, :update, :destroy]

  def index
    authorize! :index, ScheduledPhoneCall

    results = ScheduledPhoneCall.where params.permit(:state, :user_id, :owner_id)

    if params[:scheduled_after]
      results = results.where 'scheduled_at > ?', params[:scheduled_after]
    end

    results = results.order 'scheduled_at ASC'

    index_resource results.serializer
  end

  def available_times
    render_success times: @available_scheduled_phone_calls.pluck(:scheduled_at).uniq
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

  def destroy
    authorize! :delete, @scheduled_phone_call
    destroy_resource @scheduled_phone_call
  end

  private

  def load_available_scheduled_phone_calls!
    @available_scheduled_phone_calls = ScheduledPhoneCall.where(state: :assigned)
                                                         .where('scheduled_at > ?', Time.now)
  end

  # NOTE: This is super inefficient, but unfortunately our ability file is not
  # optimized for queries. See https://github.com/ryanb/cancan/wiki/Defining-Abilities
  # on how to optimize
  def filter_authorized_scheduled_phone_calls(scheduled_phone_calls)
    authorized_phone_calls = []
    scheduled_phone_calls.find_each do |p|
      authorized_phone_calls.push(p) if can? :read, p
    end
    authorized_phone_calls.sort! { |a, b | a.scheduled_at <=> b.scheduled_at }
  end

  def create_or_update_params
    permitted_params = params.require(:scheduled_phone_call).permit(:owner_id, :user_id, :scheduled_at, :state_event)

    if permitted_params[:state_event]
      permitted_params[permitted_params[:state_event].event_actor] = current_user
    else
      # If we want to create and assign at the same time
      if permitted_params[:owner_id]
        permitted_params[:state] = 'assigned'
        permitted_params[:assignor_id] = current_user.id
        permitted_params[:assigned_at] = Time.now
      end
    end

    permitted_params
  end

  def load_scheduled_phone_call!
    @scheduled_phone_call = ScheduledPhoneCall.find(params[:id])
  end
end
