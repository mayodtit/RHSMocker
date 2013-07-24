require 'spec_helper'

describe Invitation do
  it_has_a 'valid factory'
  it_validates 'presence of', :member
  it_validates 'presence of', :invited_member
  it_validates 'scoped uniqueness of', :member_id, :invited_member_id
end
