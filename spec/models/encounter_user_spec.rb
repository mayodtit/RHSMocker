require 'spec_helper'

describe EncounterUser do
  it_has_a 'valid factory'

  it_validates 'presence of', :encounter
  it_validates 'presence of', :user
end
