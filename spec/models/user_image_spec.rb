require 'spec_helper'

describe UserImage do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'allows blank uniqueness of', :client_guid
end
