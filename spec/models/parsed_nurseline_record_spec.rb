require 'spec_helper'

describe ParsedNurselineRecord do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :consult
  it_validates 'presence of', :phone_call
  it_validates 'presence of', :nurseline_record
  it_validates 'presence of', :text
  it_validates 'uniqueness of', :nurseline_record_id
end
