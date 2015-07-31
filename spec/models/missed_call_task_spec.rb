require 'spec_helper'

describe MissedCallTask do
  it_has_a 'valid factory'
  it_validates 'presence of', :phone_call
end
