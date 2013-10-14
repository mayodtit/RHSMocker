require 'spec_helper'

describe PlanOffering do
  it_has_a 'valid factory'
  it_validates 'presence of', :plan
  it_validates 'presence of', :offering
  it_validates 'inclusion of', :unlimited
  it_validates 'scoped uniqueness of', :offering_id, :plan_id
end
