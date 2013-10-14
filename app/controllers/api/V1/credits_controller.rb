class Api::V1::CreditsController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    @credits = credits_scope.all
    render_success({:credits => @credits})
  end

  def show
    @credit = credits_scope.find(params[:id])
    render_success({:credit => @credit})
  end

  def summary
    @offerings = Offering.with_credits(credits_scope.with_offering_counts)
    render_success({:offerings => @offerings})
  end

  private

  def credits_scope
    @user.credits || Credit
  end
end
