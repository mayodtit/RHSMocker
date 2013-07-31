require 'spec_helper'

describe UserDiseaseTreatment do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :treatment
end
