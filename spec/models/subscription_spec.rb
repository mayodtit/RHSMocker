require 'spec_helper'

describe Subscription do
  before do
    Subscription.any_instance.stub(:stripe_ids_present)
    Subscription.any_instance.stub(:subscribe_with_stripe!)
    Subscription.any_instance.stub(:set_user_to_premium!)
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :plan
  it_validates 'uniqueness of', :plan_id, :user_id
end
