class Api::V1::DiscountsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_discounts!

  def index
    index_resource(@discounts)
  end

  private

  def load_discounts!
    @discounts = @user.discounts
  end

  def create_attributes
    permitted_params.discounts.tap do |attributes|
      attributes[:user_id] = current_user.id
      attributes[:referral_code_id] = current_user.referral_code.id
      attributes[:referrer] = false
    end
  end
end
