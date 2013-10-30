require 'spec_helper'

describe UserAgreement do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :agreement
  it_validates 'presence of', :user_agent
  it_validates 'presence of', :ip_address
  it_validates 'uniqueness of', :agreement_id, :user_id
end
