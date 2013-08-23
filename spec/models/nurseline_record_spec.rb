require 'spec_helper'

describe NurselineRecord do
  it_has_a 'valid factory'
  it_validates 'presence of', :payload
end
