require 'spec_helper'

describe NuxStoryChange do
  it_has_a 'valid factory'
  it_validates 'presence of', :nux_story
end
