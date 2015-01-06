class Api::V1::DiscountRecordsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_discount_records!

  def index
    index_resource(@user.discount_records)
  end

  def create
    create_resource @discount_records, create_attributes
  end

  private

  def load_discount_records!
    @discount_records = @user.discount_records
  end

  def create_attributes
    permitted_params.discount_history.tap do |attributes|
      attributes[:user_id] = current_user.id
      attributes[:referral_code_id] = current_user.referral_code.id
      attributes[:referrer] = false
    end
  end
end
