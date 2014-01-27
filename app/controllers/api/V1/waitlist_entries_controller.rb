class Api::V1::WaitlistEntriesController < Api::V1::ABaseController
  def index
    authorize! :manage, WaitlistEntry
    index_resource WaitlistEntry.all
  end

  def create
    create_resource WaitlistEntry, waitlist_entry_create_attributes
  end

  private

  def authentication_check
    return if action_name == 'create' && params[:auth_token].nil?
    super
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
end
