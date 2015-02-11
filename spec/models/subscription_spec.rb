require 'spec_helper'

describe Subscription do
  it_has_a 'valid factory'
  it_validates 'foreign key of', :user
  it_validates 'presence of', :user
  it_validates 'presence of', :plan
  it_validates 'presence of', :start
  it_validates 'presence of', :status
  it_validates 'presence of', :customer
  it_validates 'presence of', :current_period_start
  it_validates 'presence of', :current_period_end
  it_validates 'presence of', :quantity
  it_validates 'presence of', :stripe_subscription_id
end
