require 'spec_helper'

describe Subscription do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :plan
  it_validates 'uniqueness of', :plan_id, :user_id
end
