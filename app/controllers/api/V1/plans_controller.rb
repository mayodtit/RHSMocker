class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_plans!

  def index
    index_resource(@plans)
  end

  private

  def load_plans!
    @plans = []
    Stripe::Plan.all.each do |plan|
      if plan.metadata[:active] == 'true'
        @plans << { id: plan.id,
                    name: plan.name,
                    description: nil,
                    price: (plan.amount / 100.0).to_s
        }
      end
    end
  end
end
