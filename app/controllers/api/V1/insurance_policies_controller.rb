class Api::V1::InsurancePoliciesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_insurance_policies!
  before_filter :load_insurance_policy!, only: %i(show update destroy)

  def index
    render_success(insurance_policies: @insurance_policies.serializer,
                   plan_types: plan_types)
  end

  def show
    show_resource @insurance_policy.serializer
  end

  def create
    create_resource @insurance_policies, insurance_policy_attributes
  end

  def update
    update_resource @insurance_policy, insurance_policy_attributes
  end

  def destroy
    destroy_resource @insurance_policy
  end

  private

  def load_insurance_policies!
    @insurance_policies = @user.insurance_policies
  end

  def load_insurance_policy!
    @insurance_policy = @insurance_policies.find(params[:id])
  end

  def plan_types
    {
        medical: {
            display_string: "Medical",
            types: %w(HMO PPO POS EPO HDHP)
        },
        dental: {
            display_string: "Dental",
            types: %w(PPO Premier)
        }
    }
  end

  def insurance_policy_attributes
    permitted_params.insurance_policy.tap do |attributes|
      add_insurance_card_image_attributes(attributes, :front)
      add_insurance_card_image_attributes(attributes, :back)
    end
  end

  def add_insurance_card_image_attributes(attributes, side)
    attributes[card_key(side)] = card_image_attributes(side) if card_image_key(side)
  end

  def card_key(side)
    "insurance_card_#{side}_attributes".to_sym
  end

  def card_image_attributes(side)
    {user: @user, image: decode_b64_image(card_image_key(side))}
  end

  def card_image_key(side)
    params.require(:insurance_policy)["insurance_card_#{side}_image".to_sym]
  end
end
