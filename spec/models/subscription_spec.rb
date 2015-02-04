require 'spec_helper'

describe Subscription do
  let(:subscription) { build(:subscription) }

  it_has_a 'valid factory'
  it_validates 'foreign key of', :user
end
