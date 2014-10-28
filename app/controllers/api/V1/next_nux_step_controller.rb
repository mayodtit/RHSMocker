class Api::V1::NextNuxStepController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    render_success({nux: next_step})
  end

  private

  def next_step
    {
      next: :credit_card,
      credit_card_description: credit_card_description,
      credit_card_action: credit_card_action
    }
  end

  def credit_card_description
    "Credit Card Description will go here, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas justo sapien, vulputate ac ligula quis, scelerisque placerat lacus."
  end

  def credit_card_action
    "Get Your Free Trial"
  end
end
