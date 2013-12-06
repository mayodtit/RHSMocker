require 'spec_helper'

describe Factor do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'allows nil inclusion of', :gender
end
