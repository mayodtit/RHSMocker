require 'spec_helper'

describe Question do
  it_has_a 'valid factory'
  it_validates 'presence of', :title
  it_validates 'presence of', :view
  it_validates 'uniqueness of', :title
  it_validates 'uniqueness of', :view
end
