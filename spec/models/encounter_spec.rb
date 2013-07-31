require 'spec_helper'

describe Encounter do
  it_has_a 'valid factory'

  it_validates 'presence of', :status
  it_validates 'inclusion of', :checked
  it_validates 'length of', :users
end
