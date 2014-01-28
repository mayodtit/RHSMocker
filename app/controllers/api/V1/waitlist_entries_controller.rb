class Api::V1::WaitlistEntriesController < Api::V1::ABaseController
  before_filter :load_waitlist_entry!, only: [:update, :destroy]

  def index
    authorize! :manage, WaitlistEntry
    index_resource WaitlistEntry.all
  end

  def create
    create_resource WaitlistEntry, waitlist_entry_create_attributes
  end

  def update
    update_resource @waitlist_entry, waitlist_entry_update_attributes
  end

  def destroy
    if @waitlist_entry.update_attributes(state_event: :revoke,
                                         revoker: current_user)
      render_success
    else
      render_failure({reason: @waitlist_entry.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def authentication_check
    return if action_name == 'create' && params[:auth_token].nil?
    super
  end

  def load_waitlist_entry!
    @waitlist_entry = WaitlistEntry.find(params[:id])
    authorize! :manage, @waitlist_entry
  end

  def waitlist_entry_create_attributes
    if current_user
      authorize! :manage, WaitlistEntry
      params.fetch(:waitlist_entry, {}).permit(:feature_group_id).tap do |attributes|
        attributes.merge!(creator: current_user, state_event: :invite)
      end
    else
      params.require(:waitlist_entry).permit(:email)
    end
  end

  def waitlist_entry_update_attributes
    params.require(:waitlist_entry).permit(:feature_group_id, :state_event).tap do |attributes|
      attributes.merge!(revoker: current_user) if attributes[:state_event] == :revoke
    end
  end
end
