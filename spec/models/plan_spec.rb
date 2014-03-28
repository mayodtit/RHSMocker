require 'spec_helper'

describe Plan do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
end
