require 'spec_helper'

describe Appointment do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :provider
  it_validates 'presence of', :scheduled_at
  it_validates 'presence of', :creator_id
end
