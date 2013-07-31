require 'spec_helper'

describe Message do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :encounter
  it_validates 'presence of', :text
end
