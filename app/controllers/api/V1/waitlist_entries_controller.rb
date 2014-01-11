class Api::V1::WaitlistEntriesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def create
    create_resource WaitlistEntry, waitlist_entry_attributes
  end

  private

  def waitlist_entry_attributes
    params.require(:waitlist_entry).permit(:email)
  end
end
