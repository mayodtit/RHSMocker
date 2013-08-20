require 'spec_helper'

describe ScheduledPhoneCall do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :scheduled_at
end
