class Api::V1::CreditsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_credit!, :only => :show

  def index
    index_resource(@user.credits)
  end

  def show
    show_resource(@credit)
  end

  def create
    create_resource(@user.credits, params[:credit])
  end

  def available
    render_success(:offerings => Offering.hash_with_credits(@user.credits.totals_for_offerings))
  end

  private

  def load_credit!
    @credit = @user.credits.find(params[:id])
  end
end
