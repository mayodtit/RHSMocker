require 'spec_helper'

describe MessageMayoVocabulary do
  it_has_a 'valid factory'

  it_validates 'presence of', :message
  it_validates 'presence of', :mayo_vocabulary
  it_validates 'uniqueness of', :mayo_vocabulary_id, :message_id
end
