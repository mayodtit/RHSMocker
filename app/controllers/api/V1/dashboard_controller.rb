class Api::V1::DashboardController < Api::V1::ABaseController
  before_filter :authorize_user!

  def index
    render_success(counts: {
                             members: Member.count,
                             contents: Content.count,
                             custom_cards: CustomCard.count,
                             custom_contents: CustomContent.count
                           })
  end

  private

  def authorize_user!
    raise CanCan::AccessDenied unless current_user.admin?
  end
end
