require 'spec_helper'

describe CustomCard do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_content
  it_validates 'presence of', :title
  it_validates 'presence of', :body
end
