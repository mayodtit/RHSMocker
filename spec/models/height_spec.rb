require 'spec_helper'

describe Height do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :amount
  it_validates 'presence of', :taken_at
  it_validates 'numericality of', :amount
end
