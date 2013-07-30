require 'spec_helper'

describe UserDiseaseUserTreatment do
  it_has_a 'valid factory'

  it_validates 'presence of', :user_disease
  it_validates 'presence of', :user_disease_treatment
  it_validates 'scoped uniqueness of', :user_disease_treatment_id, :user_disease_id
end
