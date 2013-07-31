require 'spec_helper'

describe MayoVocabulary do
  it_has_a 'valid factory'

  it_validates 'presence of', :mcvid
  it_validates 'presence of', :title
  it_validates 'uniqueness of', :mcvid
end
