require 'spec_helper'

describe PhoneCall do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :destination_phone_number
end
