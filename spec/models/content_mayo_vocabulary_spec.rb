require 'spec_helper'

describe ContentMayoVocabulary do
  it_has_a 'valid factory'

  it_validates 'presence of', :content
  it_validates 'presence of', :mayo_vocabulary
  it_validates 'uniqueness of', :mayo_vocabulary_id, :content_id
end
