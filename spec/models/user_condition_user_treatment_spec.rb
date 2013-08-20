require 'spec_helper'

describe UserConditionUserTreatment do
  it_has_a 'valid factory'

  it_validates 'presence of', :user_condition
  it_validates 'presence of', :user_treatment
  it_validates 'scoped uniqueness of', :user_treatment_id, :user_condition_id
end
