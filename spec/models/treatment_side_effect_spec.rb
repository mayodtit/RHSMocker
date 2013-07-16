require 'spec_helper'

describe TreatmentSideEffect do
  it_has_a 'valid factory'
  it_validates 'presence of', :treatment
  it_validates 'presence of', :side_effect
end
