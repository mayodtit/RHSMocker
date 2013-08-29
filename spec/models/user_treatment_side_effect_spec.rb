require 'spec_helper'

describe UserTreatmentSideEffect do
  # TODO - this is a hack to eliminate false positives resulting from dirty database
  before(:each) do
    User.delete_all
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :user_treatment
  it_validates 'presence of', :side_effect
end
