require 'spec_helper'

describe PhoneCall do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
end
