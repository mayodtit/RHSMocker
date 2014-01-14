class Api::V1::AgreementsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_agreements!
  before_filter :load_agreement!, only: :show
  before_filter :load_current_agreement!, only: :current

  def index
    index_resource @agreements
  end

  def show
    show_resource @agreement
  end

  def current
    show_resource @agreement
  end

  private

  def load_agreements!
    @agreements = Agreement.scoped
  end

  def load_agreement!
    @agreement = @agreements.find(params[:id])
  end

  def load_current_agreement!
    @agreement = @agreements.active
  end
end
