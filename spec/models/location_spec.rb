require 'spec_helper'

describe Location do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :latitude
  it_validates 'presence of', :longitude
end
