require 'spec_helper'

describe EncounterUser do
  it_has_a 'valid factory'

  it_validates 'presence of', :encounter
  it_validates 'presence of', :user
  it_validates 'scoped uniqueness of', :user_id, :encounter_id
end
