class Api::V1::DashboardController < Api::V1::ABaseController
  before_filter :authorize_user!

  def index
    render_success(counts: {
                             members: Member.count,
                             scheduled_phone_calls: -1,
                             contents: Content.count,
                             custom_cards: CustomCard.count,
                             custom_contents: CustomContent.count,
                             programs: Program.count
                           })
  end

  private

  def authorize_user!
    unless current_user.admin? || current_user.pha?
      raise CanCan::AccessDenied
    end
  end
end
