class Api::V1::InsurancePoliciesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_insurance_policies!
  before_filter :load_insurance_policy!, only: %i(show update destroy)

  def index
    index_resource @insurance_policies.serializer
  end

  def show
    show_resource @insurance_policy.serializer
  end

  def create
    create_resource @insurance_policies, permitted_params.insurance_policy
  end

  def update
    update_resource @insurance_policy, permitted_params.insurance_policy
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
end
