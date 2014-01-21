require 'spec_helper'

describe CustomCard do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_content
  it_validates 'presence of', :title
  it_validates 'presence of', :raw_preview
  it_validates 'allows blank uniqueness of', :unique_id
end
