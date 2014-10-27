class Api::V1::NextNuxStepController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    render_success({nux: next_step})
  end

  private

  def next_step
    {
      next: :credit_card
    }
  end
end
