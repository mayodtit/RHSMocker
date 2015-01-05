class Api::V1::DiscountRecordsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_discount_records!

  def create
    create_resource @discount_records, create_attributes
  end

  private

  def load_discount_records!
    @discount_records = @user.discount_records
  end

  def create_attributes
    permitted_params.discount_history.tap do |attributes|
      attributes[:re] = current_user.id
      attributes[:redeemed_at] = Time.now
      attributes[:referral_code_id] = 'to be filled'
    end
  end
end