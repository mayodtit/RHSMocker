require 'spec_helper'

describe Plan do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'presence of', :description
  it_validates 'presence of', :price
end
