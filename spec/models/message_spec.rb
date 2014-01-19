require 'spec_helper'

describe Message do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_content
  it_has_a 'valid factory', :with_phone_call
  it_has_a 'valid factory', :with_scheduled_phone_call
  it_has_a 'valid factory', :with_phone_call_summary
  it_validates 'presence of', :user
  it_validates 'presence of', :consult
  it_validates 'foreign key of', :content
  it_validates 'foreign key of', :phone_call
  it_validates 'foreign key of', :scheduled_phone_call
  it_validates 'foreign key of', :phone_call_summary
end
