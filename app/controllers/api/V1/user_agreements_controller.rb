class Api::V1::UserAgreementsController < Api::V1::ABaseController
  before_filter :load_user!

  def create
    create_resource @user.user_agreements, user_agreement_attributes
  end

  private

  def user_agreement_attributes
    params.require(:user_agreement).permit(:agreement_id).tap do |attributes|
      attributes.merge!(ip_address: request.remote_ip,
                        user_agent: request.env['HTTP_USER_AGENT'])
    end
  end
end
