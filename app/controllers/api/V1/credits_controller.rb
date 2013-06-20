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
    @credits_hash = Offering.hash_ids_to_objects(credits_scope.with_offering_counts)
    render_success({:credit_counts => @credits_hash})
  end

  private

  def load_user!
    @user = User.find(params[:user_id])
  end

  def credits_scope
    @user.user_offerings || UserOffering
  end
end
