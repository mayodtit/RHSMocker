class Api::V1::AgreementsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_agreements!

  def index
    index_resource @agreements
  end

  private

  def load_agreements!
    @agreements = Agreement.active
  end
end
