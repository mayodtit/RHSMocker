require 'spec_helper'

describe Address do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :home
  it_has_a 'valid factory', :work
  it_validates 'presence of', :user
end
