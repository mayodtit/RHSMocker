require 'spec_helper'

describe UserImage do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
end
