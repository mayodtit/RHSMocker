require 'spec_helper'

describe Metadata do
  it_has_a 'valid factory'
  it_validates 'presence of', :key
  it_validates 'presence of', :value
  it_validates 'uniqueness of', :key
end
