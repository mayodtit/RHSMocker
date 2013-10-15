require 'spec_helper'

describe Plan do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name
  it_validates 'inclusion of', :monthly
end
