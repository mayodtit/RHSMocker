class Api::V1::ReferralCodesController < Api::V1::ABaseController
  before_filter :load_referral_codes!, only: %i(index create)
  before_filter :load_referral_code!, only: %i(show update)

  def index
    index_resource @referral_codes.serializer
  end

  def show
    show_resource @referral_code.serializer
  end

  def create
    create_resource @referral_codes, create_attributes
  end

  def update
    update_resource @referral_code, permitted_params.referral_code
  end

  private

  def load_referral_codes!
    authorize! :manage, ReferralCode
    @referral_codes = ReferralCode.scoped
  end

  def load_referral_code!
    @referral_code = ReferralCode.find(params[:id])
    authorize! :manage, @referral_code
  end

  def create_attributes
    permitted_params.referral_code.tap do |attributes|
      attributes[:creator] ||= current_user
    end
  end
end
